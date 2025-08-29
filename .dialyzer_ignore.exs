[
  # Ignore Dialyzer warnings for auto-generated model files
  # These files contain repetitive struct definitions that may trigger
  # warnings that are not actionable for generated code
  ~r/lib\/docusign\/model\/.*/,
  # Ignore false positive invalid_contract warnings for FileDownloader
  # These occur when Dialyzer incorrectly infers the success typing
  {"lib/docusign/file_downloader.ex", :invalid_contract}
]
