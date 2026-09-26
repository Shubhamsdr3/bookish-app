abstract class DataMapper<Entity, Model> {
  Entity toEntity(Model model);
  Model toModel(Entity entity);
}