import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MonAssistantApp(),
    ),
  );
}

class MonAssistantApp extends StatelessWidget {
  const MonAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Équipe d\\'Assistants',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class AppState extends ChangeNotifier {
  List<Project> projects = [
    Project('Lancement Application', 'En cours', 0.6),
    Project('Rapport Mensuel', 'À faire', 0.1),
  ];

  List<Assistant> assistants = [
    Assistant('Alice (Dev)', 'Travaille sur l\\'API'),
    Assistant('Bob (Design)', 'Création des maquettes'),
    Assistant('Charlie (Analyse)', 'En attente de données'),
  ];
}

class Project {
  String name;
  String status;
  double progress;
  Project(this.name, this.status, this.progress);
}

class Assistant {
  String name;
  String currentTask;
  Assistant(this.name, this.currentTask);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    ProjectsTab(),
    ScreenTimeTab(),
    AssistantsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Centre de Contrôle'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Projets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Temps d\\'Écran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Assistants',
          ),
        ],
      ),
    );
  }
}

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestion des Projets',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(project.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Statut: ${project.status}'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: project.progress),
                        const SizedBox(height: 4),
                      ],
                    ),
                    trailing: const Icon(Icons.auto_awesome),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenTimeTab extends StatelessWidget {
  const ScreenTimeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temps d\\'Utilisation',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Temps Total Aujourd\\'hui:'),
                  Text('3h 45m', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(color: Colors.blue, value: 40, title: 'Réseaux'),
                  PieChartSectionData(color: Colors.red, value: 30, title: 'Travail'),
                  PieChartSectionData(color: Colors.green, value: 20, title: 'Vidéos'),
                  PieChartSectionData(color: Colors.orange, value: 10, title: 'Autres'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssistantsTab extends StatelessWidget {
  const AssistantsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Équipe d\\'Assistants IA',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text('Vos assistants virtuels travaillent en parallèle.'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: state.assistants.length,
              itemBuilder: (context, index) {
                final assistant = state.assistants[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.support_agent),
                    ),
                    title: Text(assistant.name),
                    subtitle: Text('Tâche actuelle: ${assistant.currentTask}'),
                    trailing: const CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
