[
  subdirectories: ["priv/*/migrations"],
  plugins: [Quokka],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  quokka: [
    # Enable all Quokka features
    autosort: [:map, :defstruct],
    inefficient_function_rewrites: true,
    # Explicitly enable all modules to ensure everything is fixed
    only: [
      :blocks,
      :comment_directives,
      :configs,
      :defs,
      :deprecations,
      :module_directives,
      :pipes,
      :single_node
    ]
  ]
]
