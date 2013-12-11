 # encoding: utf-8
        require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
        namespace :utils do
          desc "change documents attributes to document specification"
          task(:change_docs => :environment) do
            @documents = Document.all
            delivered_docs = 0
            @documents.each do |document|
              if document.print_format!=nil && document.paper_type!=nil && document.margins!=nil
                @dspec = Lists::DocumentSpecification.joins(:paper_specification => :paper_size).where("lists_paper_sizes.size = '#{document.print_format}'").joins(:paper_specification => :paper_type).where("lists_paper_types.paper_type = '#{document.paper_type}'").joins(:print_margin).where("lists_print_margins.margin = '#{document.margins}'").first
                unless @dspec.nil?
                  document.update_attribute(:document_specification_id, @dspec.id) 
                  puts "completed document #{document.id} with #{document.print_format}, #{document.paper_type}, #{document.margins} "
                  document.update_attribute(:print_format, nil)
                  document.update_attribute(:paper_type, nil)
                  document.update_attribute(:margins, nil)
                  delivered_docs = delivered_docs + 1
                end
              end
            end
            puts "all #{@documents.count} documents"
            puts "delivered #{delivered_docs} documents"
          end
        end