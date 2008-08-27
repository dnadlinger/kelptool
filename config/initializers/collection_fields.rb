#
# Based on a great idea by Jeff Dean (http://zilkey.com/2008/4/5/complex-forms-with-correct-ids).
#
# We save the elements of the association not until the main object is saved, 
# because otherwise they would be saved/changed even if a validation on the 
# main object failed.
#

module CollectionFields
  module Base
    def self.included( base )
      base.extend( ClassMethods )
    end
    
    module ClassMethods
      def attribute_for_collection( name, options = {} )
        class_eval <<-END_OF_EVAL, __FILE__, __LINE__
          after_update :save_#{ name }
          
          def save_#{ name }
            self.#{ name }.each do |element|
              element.save( false )
            end
          end
        END_OF_EVAL
        
        if options[ :build_new ]
          define_method "new_#{ name }_attributes=" do |collection_elements|
            instance_variable_set( "@#{ name }", [] ) unless self.send( name )
            collection_elements.each do |index, element_attributes|
              options[ :build_new ].call( self, element_attributes )
            end
          end
        else
          class_eval <<-END_OF_EVAL, __FILE__, __LINE__
            def new_#{ name }_attributes=( collection_elements )
              collection_elements.each do |index, element_attributes|
                self.#{ name }.build( element_attributes )
              end
            end
          END_OF_EVAL
        end
        
        if options[ :update_existing ]
          define_method "existing_#{ name }_attributes=" do |collection_elements|
            collection = self.send( name )
            collection.reject( &:new_record? ).each do |element|
              element_attributes = collection_elements[ element.id.to_s ]
              if element_attributes
                options[ :update_existing ].call( self, element_attributes, element )
              else
                collection.delete( element )
              end
            end
          end
        else
          class_eval <<-END_OF_EVAL, __FILE__, __LINE__
            def existing_#{ name }_attributes=( collection_elements )
              self.#{ name }.reject( &:new_record? ).each do |element|
                element_attributes = collection_elements[ element.id.to_s ]
                if element_attributes
                  element.attributes = element_attributes
                else
                  self.#{ name }.delete( element )
                end
              end
            end
          END_OF_EVAL
        end        
      end
    end
  end
end

ActiveRecord::Base.send( :include, CollectionFields::Base )
