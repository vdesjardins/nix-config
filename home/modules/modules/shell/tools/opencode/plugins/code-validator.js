/**
 * CodeValidator Plugin for OpenCode
 *
 * Validates code on file edits using configured check commands.
 * Runs checks and logs results to OpenCode logs.
 */

import { exec } from "child_process";
import fs from "fs";
import path from "path";
import os from "os";

// Default configuration (will be merged with loaded configs)
const DEFAULT_CONFIG = {
  checkCommands: [],
  debug: true,
  onFailure: "agent"        // "toast" | "agent" | "both"
  // agentType is not needed - OpenCode determines which agent to use
};

// Configuration will be loaded at plugin initialization
let CONFIG = { ...DEFAULT_CONFIG };

let filesEditedInSession = false;
let currentSessionId = null;

/**
 * Log helper using client.app.log()
 */
function log(client, message, extra = {}) {
  if (!CONFIG.debug) return;

  try {
    client.app.log({
      service: "CodeValidator",
      level: "debug",
      message: message,
      timestamp: new Date().toISOString(),
      ...(Object.keys(extra).length > 0 && { extra })
    });
  } catch (err) {
    console.error("[CodeValidator] Logging error:", err.message);
  }
}

/**
 * Read and parse a JSON config file
 * Throws error if file is invalid JSON
 * Returns { config, filePath } or null if file doesn't exist
 */
function readJsonConfigFile(filePath) {
   try {
     if (!fs.existsSync(filePath)) {
       return null;
     }

     const content = fs.readFileSync(filePath, 'utf-8');
     const parsed = JSON.parse(content);
     return { config: parsed, filePath };
   } catch (error) {
     console.error(`[CodeValidator] Error reading config file ${filePath}: ${error.message}`);
     throw new Error(`Invalid config file at ${filePath}: ${error.message}`);
   }
}

/**
 * Try to load config file with .json extension
 * Returns { config, filePath } or null if not found
 */
function tryLoadConfigWithExtensions(basePath) {
   const filePath = basePath + '.json';
   
   try {
     if (fs.existsSync(filePath)) {
       return readJsonConfigFile(filePath);
     }
   } catch (error) {
     // Error already logged by readJsonConfigFile
   }
   
   // No file found
   return null;
}

/**
 * Deep merge objects with special handling for arrays
 * Arrays are concatenated instead of replaced
 */
function deepMergeWithArrayConcat(target, source) {
  const result = { ...target };

  for (const key in source) {
    if (!source.hasOwnProperty(key)) continue;

    // Both are objects and not arrays: deep merge
    if (
      typeof result[key] === 'object' &&
      result[key] !== null &&
      !Array.isArray(result[key]) &&
      typeof source[key] === 'object' &&
      source[key] !== null &&
      !Array.isArray(source[key])
    ) {
      result[key] = deepMergeWithArrayConcat(result[key], source[key]);
    }
    // Both are arrays: concatenate
    else if (Array.isArray(result[key]) && Array.isArray(source[key])) {
      result[key] = [...result[key], ...source[key]];
    }
    // Otherwise: replace with source value
    else {
      result[key] = source[key];
    }
  }

  return result;
}

/**
 * Load configuration from multiple levels (hierarchical)
 * 1. Global: ~/.config/opencode/code-validator.json
 * 2. Custom: $OPENCODE_CONFIG_DIR/code-validator.json (if env var exists)
 * 3. Project: .opencode/code-validator.json
 *
 * Configs are merged with arrays concatenated
 * 
 * Returns: { config, loadedSources, loadedFiles } object for debug output handling
 */
function loadConfig(projectDirectory) {
   let config = { ...DEFAULT_CONFIG };
   const loadedSources = [];
   const loadedFiles = [];

   // 1. Load global config (try all extensions)
   const globalConfigBasePath = path.join(os.homedir(), '.config', 'opencode', 'code-validator');
   const globalConfigResult = tryLoadConfigWithExtensions(globalConfigBasePath);
   if (globalConfigResult) {
     config = deepMergeWithArrayConcat(config, globalConfigResult.config);
     loadedSources.push(`Global`);
     loadedFiles.push(globalConfigResult.filePath);
   }

   // 2. Load custom config from OPENCODE_CONFIG_DIR if set (try all extensions)
   const customConfigDir = process.env.OPENCODE_CONFIG_DIR;
   if (customConfigDir) {
     const customConfigBasePath = path.join(customConfigDir, 'code-validator');
     const customConfigResult = tryLoadConfigWithExtensions(customConfigBasePath);
     if (customConfigResult) {
       config = deepMergeWithArrayConcat(config, customConfigResult.config);
       loadedSources.push(`Custom ($OPENCODE_CONFIG_DIR)`);
       loadedFiles.push(customConfigResult.filePath);
     }
   }

   // 3. Load project config (highest priority, try all extensions)
   const projectConfigBasePath = path.join(projectDirectory, '.opencode', 'code-validator');
   const projectConfigResult = tryLoadConfigWithExtensions(projectConfigBasePath);
   if (projectConfigResult) {
     config = deepMergeWithArrayConcat(config, projectConfigResult.config);
     loadedSources.push(`Project`);
     loadedFiles.push(projectConfigResult.filePath);
   }

   // Return config and metadata (console logging deferred until debug flag is known)
   return {
     config,
     loadedSources,
     loadedFiles
   };
}

/**
 * Run validation checks
 */
async function runChecks($, client, sessionId = null) {
  // Reload configuration to ensure latest updates are applied
  const projectDir = process.cwd();
  try {
    const result = loadConfig(projectDir);
    CONFIG = result.config;
    log(client, "Configuration reloaded", { sources: result.loadedSources.join(', ') || 'defaults' });
  } catch (loadError) {
    log(client, "Failed to reload config, using existing", { error: loadError.message });
  }

  log(client, "Running validation checks", { count: CONFIG.checkCommands.length });

  const results = [];

  for (const command of CONFIG.checkCommands) {
    log(client, "Executing command", { command });

    try {
      // Use child_process.exec() to inherit full shell environment
      // Add 30-second timeout to prevent hanging
      const result = await new Promise((resolve) => {
        let timedOut = false;
        const timeout = setTimeout(() => {
          timedOut = true;
          log(client, "Check timed out after 30 seconds", { command });
          resolve({
            command,
            success: false,
            exitCode: 124,  // Timeout exit code
            output: "",
            error: "Command execution timed out after 30 seconds"
          });
        }, 30000);

        const proc = exec(command, (error, stdout, stderr) => {
          if (timedOut) return;  // Already timed out, ignore callback
          clearTimeout(timeout);
          
          const exitCode = error?.code || 0;
          
          log(client, "Check completed", {
            command,
            exitCode,
            success: exitCode === 0
          });

          resolve({
            command,
            success: exitCode === 0,
            exitCode,
            output: stdout || "",
            error: stderr || error?.message || ""
          });
        });
      });

      results.push(result);
    } catch (error) {
      log(client, "Check failed with error", {
        command,
        error: error.message
      });

      results.push({
        command,
        success: false,
        exitCode: 1,
        output: "",
        error: error.message
      });
    }
  }

  const passed = results.filter(r => r.success).length;
  const failed = results.filter(r => !r.success).length;

  log(client, "Validation complete", {
    total: results.length,
    passed,
    failed
  });

  // Handle results based on configuration
  try {
    if (failed === 0) {
      // Always show success toast
      await client.tui.showToast({
        body: {
          message: "✅ Validation Passed",
          variant: "success"
        }
      });
      return results;
    }

    // Handle failures based on CONFIG.onFailure
    if (CONFIG.onFailure === "toast") {
      // Just show error toast
      log(client, "Showing error toast (onFailure=toast)");
      await client.tui.showToast({
        body: {
          message: `❌ Validation Failed: ${failed} check(s) failed`,
          variant: "error"
        }
      });
      return results;
    }

    if (CONFIG.onFailure === "agent" || CONFIG.onFailure === "both") {
      // Show error toast if "both"
      if (CONFIG.onFailure === "both") {
        log(client, "Showing error toast before agent attempt (onFailure=both)");
        await client.tui.showToast({
          body: {
            message: `❌ Validation Failed: ${failed} check(s) failed`,
            variant: "error"
          }
        });
      }

      // Try to fix with agent
      log(client, "Attempting to fix errors with agent", {
        onFailure: CONFIG.onFailure
      });

      const fixResult = await fixErrorsWithAgent(client, $, results, sessionId);

      // Show toast indicating we sent to agent
      try {
        await client.tui.showToast({
          body: {
            message: "⚠️ Validation failed. Errors sent to agent for review.",
            variant: "warning"
          }
        });
      } catch (err) {
        log(client, "Toast notification error", { error: err.message });
      }

      return fixResult.finalResults;
    }

    // Fallback: show error toast if onFailure is unknown
    log(client, "Unknown onFailure mode, showing error toast", { mode: CONFIG.onFailure });
    await client.tui.showToast({
      body: {
        message: `❌ Validation Failed: ${failed} check(s) failed`,
        variant: "error"
      }
    });
    return results;

  } catch (err) {
    log(client, "Toast notification or agent error", { error: err.message });
    return results;
  }
}

/**
 * Fix validation errors using an agent
 * Appends error details to prompt for agent to see and fix
 */
async function fixErrorsWithAgent(client, $, failedResults, sessionId) {
  log(client, "Starting agent-based error fixing", {
    failedCount: failedResults.filter(r => !r.success).length,
    agentType: CONFIG.agentType
  });

  try {
    // Get failed checks
    const failedChecks = failedResults.filter(r => !r.success);

    // Format error context (Option A: Raw output)
    const errorContext = failedChecks.map(check => `
Command: ${check.command}
Exit code: ${check.exitCode}

Error output:
${check.error}

Standard output:
${check.output}
`).join('\n---\n');

    // Create error summary to append to prompt
    const errorSummary = `Please fix these validation errors:

${errorContext}

Instructions: Apply fixes directly to files. Do NOT commit changes.`;

    log(client, "Appending error context to prompt", {
      failedChecks: failedChecks.length
    });

       // Append error details to the prompt for user visibility
       try {
         await client.tui.appendPrompt({
           body: {
             text: errorSummary
           }
         });
         log(client, "Error details appended to prompt");
         
         // Add small delay to ensure prompt is rendered before submission
         await new Promise(resolve => setTimeout(resolve, 100));
         
         // Submit the prompt to trigger agent response
         log(client, "Submitting prompt via tui.submitPrompt()");
         const submitResult = await client.tui.submitPrompt();
         log(client, "Prompt submitted", { submitResult });
         
       } catch (err) {
         log(client, "Warning: Could not append to prompt or submit", {
           error: err.message
         });
       }

     // Show toast indicating action taken
     try {
       await client.tui.showToast({
         body: {
           message: "🔧 Validation errors sent to agent for fixing.",
           variant: "info"
         }
       });
     } catch (err) {
       log(client, "Toast notification error", { error: err.message });
     }

    return {
      success: false,  // We're not actually fixing, just appending for agent to see
      attempts: 1,
      finalResults: failedResults,
      note: "Errors appended to prompt for agent to review and fix"
    };

  } catch (error) {
    log(client, "Error in agent workflow", {
      error: error.message
    });

    return {
      success: false,
      attempts: 0,
      finalResults: failedResults
    };
  }
}

/**
 * Main plugin export
 */
export const CodeValidatorPlugin = async ({ client, $ }) => {
   try {
     // Load configuration from hierarchical sources
     // Get the project directory (parent of .opencode directory)
     const projectDir = process.cwd();
     
     let loadedSources = [];
     let loadedFiles = [];
     try {
       const result = loadConfig(projectDir);
       CONFIG = result.config;
       loadedSources = result.loadedSources;
       loadedFiles = result.loadedFiles;
     } catch (loadError) {
       console.error("[CodeValidator] Failed to load config, using defaults:", loadError.message);
       // Keep using DEFAULT_CONFIG if loading fails
       CONFIG = { ...DEFAULT_CONFIG };
     }

     // Log config loading info via OpenCode logs (respects debug flag)
     log(client, "Configuration loaded", {
       sources: loadedSources.join(', ') || 'defaults',
       files: loadedFiles
     });

     log(client, "Plugin initialized", {
       projectDir,
       checkCommands: CONFIG.checkCommands.length,
       onFailure: CONFIG.onFailure
     });

    return {
      /**
       * Generic event handler that catches all events
       */
      event: async ({ event }) => {
        try {
          // Handle file edits
          if (event.type === "file.edited") {
            filesEditedInSession = true;
            log(client, "File edited, flag set", { path: event.path });
          }

          // Handle session creation
          if (event.type === "session.created") {
            currentSessionId = event.id;
            log(client, "Session created", { sessionId: event.id });
            filesEditedInSession = false;
            log(client, "Flag reset for new session");
          }

          // Handle session idle
          if (event.type === "session.idle") {
            log(client, "Session idle event triggered", {
              filesEdited: filesEditedInSession
            });

            if (filesEditedInSession) {
              log(client, "Edits detected, running validation checks");
              await runChecks($, client, currentSessionId);
              filesEditedInSession = false;
            } else {
              log(client, "No edits detected during session, skipping validation");
            }
          }
        } catch (err) {
          log(client, "Event handler error", { error: err.message });
        }
      }
    };
  } catch (err) {
    console.error("[CodeValidator] Plugin initialization error:", err);
    throw err;
  }
};

export default CodeValidatorPlugin;
