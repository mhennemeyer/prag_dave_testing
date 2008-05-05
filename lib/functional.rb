module PragDaveTesting
  class Functional
    class << self
      def functional(controller, &block)
        return unless rails_test?
  
        controller_name   = controller.to_s.sub(/_controller/, '')
        controller        = controller_name + "_controller"
  
        @controller_class = eval("#{controller.camelize}")
        @controller       = @controller_class.new
        @request          = ActionController::TestRequest.new
        @response         = ActionController::TestResponse.new
  
        # ActionController::Routing::Routes.draw do |map|
        #   map.resources controller_name.to_sym
        # end
  
        def assigns(sym)
          @controller.assigns[sym.to_s]
        end
  
        def build_request_uri(action, parameters)
          return if @request.env['REQUEST_URI']

          options = @controller.send :rewrite_options, parameters
          options.update :only_path => true, :action => action

          url = ActionController::UrlRewriter.new @request, parameters
          @request.set_REQUEST_URI url.rewrite(options)
        end
  
        def get(action, parameters = nil)
          @request.env['REQUEST_METHOD'] = 'GET'
          process action, parameters
        end
  
        def process(action, parameters = nil)
          parameters ||= {}

          @request.recycle!
          @request.env['REQUEST_METHOD'] ||= 'GET'
          @request.action = action.to_s

          @request.assign_parameters @controller_class.controller_path, action.to_s,
                                     parameters

          build_request_uri action, parameters

          @controller.process @request, @response
        end
  
        def head(action, parameters = nil)
          @request.env['REQUEST_METHOD'] = 'HEAD'
          process action, parameters
        end
  
        def post(action, parameters = nil)
          @request.env['REQUEST_METHOD'] = 'POST'
          process action, parameters
        end
  
        ##
        # Performs a PUT request on +action+ with +params+.
  
        def put(action, parameters = nil)
          @request.env['REQUEST_METHOD'] = 'PUT'
          process action, parameters
        end
  
        ##
        # Performs a DELETE request on +action+ with +params+.
  
        def delete(action, parameters = nil)
          @request.env['REQUEST_METHOD'] = 'DELETE'
          process action, parameters
        end
  
        ##
        # Performs a XMLHttpRequest request using +request_method+ on +action+ with
        # +params+.
  
        def xml_http_request(request_method, action, parameters = nil)
          @request.env['REQUEST_METHOD'] = request_method.to_s
  
          @request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
          @request.env['HTTP_ACCEPT'] = 'text/javascript, text/html, application/xml, text/xml, */*'
  
          result = process action, parameters
  
          @request.env.delete 'HTTP_X_REQUESTED_WITH'
          @request.env.delete 'HTTP_ACCEPT'
  
          return result
        end
  
        ##
        # Friendly alias for xml_http_request
  
        alias xhr xml_http_request
  

        #Test::Rails::ControllerTestCase.new.instance_eval &block

        #   self.use_transactional_fixtures = true
        #   self.use_instantiated_fixtures = false
        # 
        #   NOTHING = Object.new # :nodoc:
        # 
        #   DEFAULT_ASSIGNS = %w[
        #     _cookies _flash _headers _params _request _response _session
        # 
        #     cookies flash headers params request response session
        # 
        #     action_name
        #     before_filter_chain_aborted
        #     db_rt_after_render
        #     db_rt_before_render
        #     ignore_missing_templates
        #     loggedin_user
        #     logger
        #     rendering_runtime
        #     request_origin
        #     template
        #     template_class
        #     template_root
        #     url
        #     user
        #     variables_added
        #   ]
        # 
        #   def setup
        #     return if self.class == Test::Rails::ControllerTestCase
        # 
        #     @controller_class_name ||= self.class.name.sub 'Test', ''
        # 
        #     super
        # 
        #     @controller_class.send(:define_method, :rescue_action) { |e| raise e }
        # 
        #     @deliveries = []
        #     ActionMailer::Base.deliveries = @deliveries
        # 
        #     # used by util_audit_assert_assigns
        #     @assigns_asserted = []
        #     @assigns_ignored ||= [] # untested assigns to ignore
        #   end
        # 
        #   ##
        #   # Excutes the request +action+ with +params+.
        #   #
        #   # See also: get, post, put, delete, head, xml_http_request
        # 
        #   def process(action, parameters = nil)
        #     parameters ||= {}
        # 
        #     @request.recycle!
        #     @request.env['REQUEST_METHOD'] ||= 'GET'
        #     @request.action = action.to_s
        # 
        #     @request.assign_parameters @controller_class.controller_path, action.to_s,
        #                                parameters
        # 
        #     build_request_uri action, parameters
        # 
        #     @controller.process @request, @response
        #   end
        # 
        #   ##
        #   # Performs a GET request on +action+ with +params+.
        # 
        #   def get(action, parameters = nil)
        #     @request.env['REQUEST_METHOD'] = 'GET'
        #     process action, parameters
        #   end
        # 
        #   ##
        #   # Performs a HEAD request on +action+ with +params+.
        # 
        #   def head(action, parameters = nil)
        #     @request.env['REQUEST_METHOD'] = 'HEAD'
        #     process action, parameters
        #   end
        # 
        #   ##
        #   # Performs a POST request on +action+ with +params+.
        # 
        #   def post(action, parameters = nil)
        #     @request.env['REQUEST_METHOD'] = 'POST'
        #     process action, parameters
        #   end
        # 
        #   ##
        #   # Performs a PUT request on +action+ with +params+.
        # 
        #   def put(action, parameters = nil)
        #     @request.env['REQUEST_METHOD'] = 'PUT'
        #     process action, parameters
        #   end
        # 
        #   ##
        #   # Performs a DELETE request on +action+ with +params+.
        # 
        #   def delete(action, parameters = nil)
        #     @request.env['REQUEST_METHOD'] = 'DELETE'
        #     process action, parameters
        #   end
        # 
        #   ##
        #   # Performs a XMLHttpRequest request using +request_method+ on +action+ with
        #   # +params+.
        # 
        #   def xml_http_request(request_method, action, parameters = nil)
        #     @request.env['REQUEST_METHOD'] = request_method.to_s
        # 
        #     @request.env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest'
        #     @request.env['HTTP_ACCEPT'] = 'text/javascript, text/html, application/xml, text/xml, */*'
        # 
        #     result = process action, parameters
        # 
        #     @request.env.delete 'HTTP_X_REQUESTED_WITH'
        #     @request.env.delete 'HTTP_ACCEPT'
        # 
        #     return result
        #   end
        # 
        #   ##
        #   # Friendly alias for xml_http_request
        # 
        #   alias xhr xml_http_request
        # 
        #   ##
        #   # Asserts that the assigns variable +ivar+ is assigned to +value+. If
        #   # +value+ is omitted, asserts that assigns variable +ivar+ exists.
        # 
        #   def assert_assigned(ivar, value = NOTHING)
        #     ivar = ivar.to_s
        #     @assigns_asserted << ivar
        #     assert_includes ivar, assigns, "#{ivar.inspect} missing from assigns"
        #     unless value.equal? NOTHING then
        #       assert_equal value, assigns[ivar],
        #                    "assert_assigned #{ivar.intern.inspect}"
        #     end
        #   end
        # 
        #   ##
        #   # Asserts the response content type matches +type+.
        # 
        #   def assert_content_type(type, message = nil)
        #     assert_equal type, @response.headers['Content-Type'], message
        #   end
        # 
        # 
        #   def assert_flash(key, content)
        #     assert flash.include?(key),
        #            "#{key.inspect} missing from flash, has #{flash.keys.inspect}"
        # 
        #     case content
        #     when Regexp then
        #       assert_match content, flash[key],
        #                    "Content of flash[#{key.inspect}] did not match"
        #     else
        #       assert_equal content, flash[key],
        #                    "Incorrect content in flash[#{key.inspect}]"
        #     end
        #   end
        # 
        #   ##
        #   # Asserts that the assigns variable +ivar+ is not set.
        # 
        #   def deny_assigned(ivar)
        #     ivar = ivar.to_s
        #     deny_includes ivar, assigns
        #   end
        # 
        #   def util_audit_assert_assigned
        #     return unless @test_passed
        #     return unless @controller.send :performed?
        #     all_assigns = assigns.keys.sort
        # 
        #     assigns_ignored = DEFAULT_ASSIGNS | @assigns_ignored
        #     assigns_ignored = assigns_ignored.map { |a| a.to_s }
        # 
        #     assigns_created = all_assigns - assigns_ignored
        #     assigns_asserted = @assigns_asserted - assigns_ignored
        # 
        #     assigns_missing = assigns_created - assigns_asserted
        # 
        #     return if assigns_missing.empty?
        # 
        #     message = []
        #     message << "You are missing these assert_assigned assertions:"
        #     assigns_missing.sort.each do |ivar|
        #       message << "    assert_assigned #{ivar.intern.inspect} #, :some_value"
        #     end
        #     message << nil # stupid '.'
        # 
        #     flunk message.join("\n")
        #   end
        # 
        #   private
        # 
        #   def build_request_uri(action, parameters)
        #     return if @request.env['REQUEST_URI']
        # 
        #     options = @controller.send :rewrite_options, parameters
        #     options.update :only_path => true, :action => action
        # 
        #     url = ActionController::UrlRewriter.new @request, parameters
        #     @request.set_REQUEST_URI url.rewrite(options)
        #   end 
        # 
        # end
  

  
        instance_eval(&block)
      
      end
    end
  end
end