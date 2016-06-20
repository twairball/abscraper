module Watir

    ##
    ## extend Watir::ElementLocator to include custom attributes
    ##
    class ElementLocator    
        alias :old_normalize_selector :normalize_selector
         
        def normalize_selector(how, what)
            case how
                ##
                ## dianping shop detail
                ##
                when :itemprop
                    [how, what]
                else
                    old_normalize_selector(how, what)
            end
        end
    end
end
