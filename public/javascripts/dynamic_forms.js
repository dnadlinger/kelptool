var CollectionFields = Class.create( {
  initialize: function( parentId, startIndex, htmlTemplate ) {
    this.parentId = parentId;    
    this.currentIndex = startIndex;
    this.htmlTemplate = htmlTemplate;
  },
  
  generateElement: function() {
    return this.htmlTemplate.replace( /LIST_POSITION/g, this.currentIndex++ );
  },
  
  addChild: function() {
    new Insertion.Bottom( $( this.parentId ), this.generateElement() );
  }
} );