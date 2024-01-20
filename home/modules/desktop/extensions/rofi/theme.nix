{mkLiteral}: {
  "*" = {
    "bg0" = mkLiteral "#24283B";
    "bg1" = mkLiteral "#3B4252";
    "fg0" = mkLiteral "#C0CAF5";

    "accent-color" = mkLiteral "#7AA2F7";
    "urgent-color" = mkLiteral "#F7768E";

    "background-color" = mkLiteral "transparent";
    "text-color" = mkLiteral "@fg0";

    "margin" = mkLiteral "0";
    "padding" = mkLiteral "0";
    "spacing" = mkLiteral "0";
  };

  "window" = {
    "location" = mkLiteral "center";
    "width" = mkLiteral "900";

    "background-color" = mkLiteral "@bg0";
    "border-color" = mkLiteral "@bg1";
    "border" = mkLiteral "2px";
  };

  "inputbar" = {
    "spacing" = mkLiteral "8px";
    "padding" = mkLiteral "8px";

    "background-color" = mkLiteral "@bg1";
  };

  "prompt, entry, element-icon, element-text" = {
    "vertical-align" = mkLiteral "0.5";
  };

  "prompt" = {
    "text-color" = mkLiteral "@accent-color";
  };

  "textbox" = {
    "padding" = mkLiteral "8px";
    "background-color" = mkLiteral "@bg1";
  };

  "listview" = {
    "padding" = mkLiteral "4px 0";
    "lines" = mkLiteral "8";
    "columns" = mkLiteral "1";

    fixed-height = mkLiteral "false";
  };

  "element" = {
    "padding" = mkLiteral "8px";
    "spacing" = mkLiteral "8px";
  };

  "element normal normal" = {
    "text-color" = mkLiteral "@fg0";
  };

  "element normal urgent" = {
    "text-color" = mkLiteral "@urgent-color";
  };

  "element normal active" = {
    "text-color" = mkLiteral "@accent-color";
  };

  "element selected" = {
    "text-color" = mkLiteral "@bg0";
  };

  "element selected normal, element selected active" = {
    "background-color" = mkLiteral "@accent-color";
  };

  "element selected urgent" = {
    "background-color" = mkLiteral "@urgent-color";
  };

  "element-icon" = {
    "size" = mkLiteral "0.8em";
  };

  "element-text" = {
    "text-color" = mkLiteral "inherit";
  };
}
