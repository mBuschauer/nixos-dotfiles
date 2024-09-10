{ inputs, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.debugpy # Python Debugger
      ms-vscode-remote.remote-containers # Dev Containers
      ms-azuretools.vscode-docker # docker
      yzhang.markdown-all-in-one # markdown-all-in-one
      bbenoist.nix # nix
      jnoortheen.nix-ide #nix IDE
      ms-python.python # Python
      ms-python.vscode-pylance # vscode-pylance
      rust-lang.rust-analyzer # rust-analyzer
      vscode-icons-team.vscode-icons # vscode-icons
      dotjoshjohnson.xml # xml tools
      eamodio.gitlens # git lens

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "autopep8";
        publisher = "ms-python";
        version = "2024.0.0";
        sha256 = "37d6d46763ada1846d2c468a47274510f392f28922d44e339ab8f5baf6aa0703";
      }
      {
        name = "Bend";
        publisher = "rohanvashisht";
        version="0.2.14";
        sha256 = "63c73c0791f33082fbfc81c54dc8b2ac08a5a482226c1598b2c25e3b37f8252a";
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = "mBuschauer";
    userEmail = "marco@buschauer.us";
  };

  imports = [
    inputs.tailray.homeManagerModules.default
  ];
}