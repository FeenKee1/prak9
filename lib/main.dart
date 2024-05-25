import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

void setupLocator() {
  GetIt.I.registerLazySingleton<StudentService>(() => StudentService());
}

class Student {
  int id;
  String name;
  int age;

  Student(this.id, this.name, this.age);
}

class StudentService {
  List<Student> _students = [];

  List<Student> get students => _students;

  void addStudent(String name, int age) {
    int id = _students.isEmpty ? 1 : _students.last.id + 1;
    _students.add(Student(id, name, age));
  }

  void removeStudent() {
    if (_students.isNotEmpty) {
      _students.removeLast();
    }
  }
}

class StudentInheritedWidget extends InheritedWidget {
  final StudentService studentService;

  const StudentInheritedWidget({
    Key? key,
    required this.studentService,
    required Widget child,
  }) : super(key: key, child: child);

  static StudentInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StudentInheritedWidget>()!;
  }

  @override
  bool updateShouldNotify(StudentInheritedWidget oldWidget) {
    return oldWidget.studentService != studentService;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StudentInheritedWidget(
      studentService: GetIt.I<StudentService>(),
      child: MaterialApp(
        title: 'Student List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/column': (context) => ColumnScreen(),
          '/listview': (context) => ListViewScreen(),
          '/separated_listview': (context) => SeparatedListViewScreen(),
          '/vertical_navigation': (context) => VerticalNavigationScreen(),
          '/horizontal_navigation': (context) => HorizontalNavigationScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: 'https://sh11-krkam.edusite.ru/images/p58_shkolakartinka.jpg',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/column');
              },
              child: Text('Column'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listview');
              },
              child: Text('ListView'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/separated_listview');
              },
              child: Text('Separated ListView'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vertical_navigation');
              },
              child: Text('Vertical Navigation'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/horizontal_navigation');
              },
              child: Text('Horizontal Navigation'),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnScreen extends StatefulWidget {
  @override
  _ColumnScreenState createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentService = StudentInheritedWidget.of(context).studentService;

    return Scaffold(
      appBar: AppBar(
        title: Text('Column'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://png.pngtree.com/png-clipart/20201123/ourlarge/pngtree-school-building-cute-school-png-image_2461447.jpg',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              'Student List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: studentService.students.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: studentService.students.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(studentService.students[index].name),
                    subtitle: Text("Age: ${studentService.students[index].age}"),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            buildAddStudentForm(studentService),
          ],
        ),
      ),
    );
  }

  Widget buildAddStudentForm(StudentService studentService) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            int age = int.parse(ageController.text);
            studentService.addStudent(name, age);
            nameController.clear();
            ageController.clear();
            setState(() {});
          },
          child: Text('Add'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            studentService.removeStudent();
            setState(() {});
          },
          child: Text('Remove'),
        ),
      ],
    );
  }
}

class ListViewScreen extends StatefulWidget {
  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentService = StudentInheritedWidget.of(context).studentService;

    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://png.pngtree.com/png-clipart/20201123/ourlarge/pngtree-school-building-cute-school-png-image_2461447.jpg',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              'Student List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: studentService.students.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: studentService.students.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(studentService.students[index].name),
                    subtitle: Text("Age: ${studentService.students[index].age}"),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            buildAddStudentForm(studentService),
          ],
        ),
      ),
    );
  }

  Widget buildAddStudentForm(StudentService studentService) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            int age = int.parse(ageController.text);
            studentService.addStudent(name, age);
            nameController.clear();
            ageController.clear();
            setState(() {});
          },
          child: Text('Add'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            studentService.removeStudent();
            setState(() {});
          },
          child: Text('Remove'),
        ),
      ],
    );
  }
}

class SeparatedListViewScreen extends StatefulWidget {
  @override
  _SeparatedListViewScreenState createState() => _SeparatedListViewScreenState();
}

class _SeparatedListViewScreenState extends State<SeparatedListViewScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentService = StudentInheritedWidget.of(context).studentService;

    return Scaffold(
      appBar: AppBar(
        title: Text('Separated ListView'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://png.pngtree.com/png-clipart/20201123/ourlarge/pngtree-school-building-cute-school-png-image_2461447.jpg',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              'Student List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: studentService.students.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                itemCount: studentService.students.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(studentService.students[index].name),
                    subtitle: Text("Age: ${studentService.students[index].age}"),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
            SizedBox(height: 8),
            buildAddStudentForm(studentService),
          ],
        ),
      ),
    );
  }

  Widget buildAddStudentForm(StudentService studentService) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            int age = int.parse(ageController.text);
            studentService.addStudent(name, age);
            nameController.clear();
            ageController.clear();
            setState(() {});
          },
          child: Text('Add'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            studentService.removeStudent();
            setState(() {});
          },
          child: Text('Remove'),
        ),
      ],
    );
  }
}

class VerticalNavigationScreen extends StatefulWidget {
  @override
  _VerticalNavigationScreenState createState() => _VerticalNavigationScreenState();
}

class _VerticalNavigationScreenState extends State<VerticalNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Settings Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vertical Navigation'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HorizontalNavigationScreen extends StatefulWidget {
  @override
  _HorizontalNavigationScreenState createState() => _HorizontalNavigationScreenState();
}

class _HorizontalNavigationScreenState extends State<HorizontalNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Settings Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal Navigation'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://png.pngtree.com/png-clipart/20201123/ourlarge/pngtree-school-building-cute-school-png-image_2461447.jpg',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

