class ProfilerCase {
  final String title;
  final String description;

  const ProfilerCase({required this.title, required this.description});
}

const List<ProfilerCase> profilerCases = [
  ProfilerCase(
    title: 'Caso 1',
    description: 'Scroll con tirones',
  ),
  ProfilerCase(
    title: 'Caso 2',
    description: 'Interacción costosa',
  ),
  ProfilerCase(
    title: 'Caso 3',
    description: 'Cambio de estado sospechoso',
  ),
  ProfilerCase(
    title: 'Caso 4',
    description: 'Memoria creciente',
  ),
];
