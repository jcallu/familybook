class Like < Socialization::ActiveRecordStores::Like
  
  include FamilyHelper 
    
  include PublicActivity::Model

  tracked owner: ->(controller, model) { controller && controller.current_user }  
end
