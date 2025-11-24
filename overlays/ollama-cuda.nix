final: prev: {
  ollama-cuda = prev.ollama-cuda.overrideAttrs (finalA: prevA: {
    version = "0.13.0";

    src = prevA.src.override {
      tag = "v0.13.0";
      hash = "sha256-VhBPYf/beWkeFCdBTC2UpxqQUgEX8TCkbiWBPg8gDb4=";
    };

    vendorHash = "sha256-rKRRcwmon/3K2bN7iQaMap5yNYKMCZ7P0M1C2hv4IlQ=";

    postInstall = prevA.postInstall + ''
      ln -s ollama "$out/bin/app"
    '';
  });
}