class TestingModelGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_path, class_name, "#{class_name}Test"

      # Model and test directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('test/unit', class_path)

      # Model class, testing file
      m.template 'model.rb',      File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'testing.rb',  File.join('test/unit', class_path, "#{file_name}_test.rb")

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end

  protected
    def banner
      "Usage: #{$0} #{spec.name} ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end
end
