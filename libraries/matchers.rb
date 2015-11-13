if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1

  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1

  end

  # config
  
end
