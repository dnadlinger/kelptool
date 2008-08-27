#
# Based on a great idea by Jeff Dean (http://zilkey.com/2008/4/5/complex-forms-with-correct-ids).
#
# We save the elements of the association not until the main object is saved, 
# because otherwise they would be saved/changed even if a validation on the 
# main object failed and it didn't get saved.
#
# We have to make sure that the existing_#{ name }_attributes hash is set on
# every mass assign operation, even if it is not passed in the attributes
# (i.e. if all existing_#{ name }_attributes-fields were removed from the form),
# because otherwise the relations would not be removed properly.
#
# In existing_#{ name }_attributes= we check if the collection actually exists.
# We do this in order to support non-ActiveRecord::AssociationCollection
# attributes, e.g. in models without database table, for those are not
# automatically initialized with an empty array and thus might be nil.

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
          
          def attributes_with_#{ name }=( new_attributes, *args )
            self.send( :attributes_without_#{ name }=, new_attributes.with_indifferent_access.reverse_merge( 'existing_#{ name }_attributes' => {} ), *args )
          end
          alias_method_chain :attributes=, :#{ name }
        END_OF_EVAL
        
        # Check if there is a custom build proc set, otherwise use the 
        # faster class_eval approach.
        if options[ :build_new ]
          define_method "new_#{ name }_attributes=" do |collection_elements|
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
        
        # Check if there is a custom update proc set, otherwise use the 
        # faster class_eval approach.
        if options[ :update_existing ]
          define_method "existing_#{ name }_attributes=" do |collection_elements|
            collection = self.send( name )
            return unless collection
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
              return unless self.#{ name }
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
