 # encoding: utf-8
        require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
        namespace :utils do
          desc "change documents attributes from document_specification to paper_specification"
          task(:change_docs => :environment) do
            @documents = Document.all
            delivered_docs = 0
            @documents.each do |document|
                @dspec = document.document_specification
                unless @dspec.nil?
                  @pspec = document.get_paper_specification
                  @pmargin = document.get_print_margins
                  document.update_attribute(:paper_specification_id, @pspec.id) 
                  document.update_attribute(:print_margin_id, @pmargin.id) 
                  document.update_attribute(:cost, document.price) 
                
                  puts "completed document #{document.id} with pspec_id = #{document.paper_specification_id}, pmargin =  #{document.print_margin_id} "
                  delivered_docs = delivered_docs + 1
              end
            end
            puts "all #{@documents.count} documents"
            puts "delivered #{delivered_docs} documents"
          end
        end