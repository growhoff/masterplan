abstract class Mapper<Dto, Model> {
  Model fromDto(Dto dto);

  List<Model> listFromDto(List<Dto> dtosList) =>
      dtosList.map(fromDto).toList().whereType<Model>().toList();
}
