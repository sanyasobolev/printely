        require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
        namespace :utils do
          desc "change documents attributes to document specification"
          task(:change_docs => :environment) do
            @documents = Document.all
            @documents.each do |document|
              if document.print_format!=nil && document.paper_type!=nil && document.margins!=nil
                @dspec = Lists::DocumentSpecification.joins(:paper_specification => :paper_size).where("lists_paper_sizes.size = '#{document.print_format}'").joins(:paper_specification => :paper_type).where("lists_paper_types.paper_type = '#{document.paper_type}'").joins(:print_margin).where("lists_print_margins.margin = '#{document.margins}'").first
                document.document_specification = @dspec
                document.save 
                document.print_format = nil
                document.paper_type = nil
                document.margins= nil
                puts "completed document #{document.id}"
              end
            end
          end
        end