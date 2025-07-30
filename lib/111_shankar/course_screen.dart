import '../111_shankar/learning_module_screen.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text(
          "Course",
          textScaler: TextScaler.linear(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications_none_outlined, color: Colors.white),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/flutter_course.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(12),
                child: const Text(
                  'Flutter Course Map',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: "Beginner Fundamentals"),
            const CourseGrid(levelStart: 0, levelCount: 4),
            const SizedBox(height: 24),
            const SectionTitle(title: "Intermediate Mastery"),
            const CourseGrid(levelStart: 4, levelCount: 4),
            const SizedBox(height: 24),
            const SectionTitle(title: "Advanced Expertise"),
            const CourseGrid(levelStart: 8, levelCount: 4),
          ],
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("New Screen"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to the New Screen!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "This screen was opened by clicking the banner on the Course Screen.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseGrid extends StatelessWidget {
  final int levelStart;
  final int levelCount;
  const CourseGrid({required this.levelStart, required this.levelCount, super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> levelSubtitles = [
      // Beginner
      "Learn basic layout widgets like Container, Column, and Row",
      "Master scrolling widgets, image handling, and asset management",
      "Understand app structure with AppBar, Drawer, Tabs, and Slivers",
      "Explore input widgets and basic animations with TextFields and Sliders",
      // Intermediate
      "Implement clipping techniques and gradients with StatefulWidgets",
      "Use Material widgets and create Hero animations",
      "Build adaptive layouts with chips and scrollable tools",
      "Create flexible layouts with advanced animations and responsiveness",
      // Advanced
      "Design custom page transitions and draggable widgets",
      "Master navigation patterns and inherited widgets",
      "Handle asynchronous UI with FutureBuilder and LayoutBuilder",
      "Implement state management with ChangeNotifier and ValueNotifier"
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: levelSubtitles.length, // Expand based on levelSubtitles
      itemBuilder: (context, index) {
        final levelIndex = levelStart + index;
        if (levelIndex >= levelSubtitles.length) {
          return const SizedBox.shrink(); // Safety for out-of-bounds
        }
        final section = CourseSection(
          title: 'Level ${levelIndex + 1}',
          subtitle: levelSubtitles[levelIndex],
          progress: levelIndex < 2 ? 1.0 : (levelIndex == 2 ? 0.5 : 0.0),
          locked: levelIndex > 2,
          completed: levelIndex < 2,
        );
        return GestureDetector(
          onTap: () {
            if (!section.locked) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TopicListScreen(
                    title: section.title,
                    topics: getTopicsByLevel(levelIndex),
                  ),
                ),
              );
            }
          },
          child: CourseCard(course: section),
    //  GridView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     crossAxisSpacing: 16,
    //     mainAxisSpacing: 16,
    //     childAspectRatio: 0.85,
    //   ),
    //   itemCount: levelCount,
    //   itemBuilder: (context, index) {
    //     final levelIndex = levelStart + index;
    //     final section = CourseSection(
    //       title: "Level ${levelIndex + 1}",
    //       subtitle: levelSubtitles[levelIndex],
    //       progress: levelIndex < 2 ? 1.0 : (levelIndex == 2 ? 0.5 : 0.0),
    //       locked: levelIndex > 2,
    //       completed: levelIndex < 2,
    //     );
    //     return GestureDetector(
    //       onTap: () {
    //         if (!section.locked) {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (_) => TopicListScreen(
    //                 title: section.title,
    //                 topics: getTopicsByLevel(levelIndex),
    //               ),
    //             ),
    //           );
    //         }
    //       },
    //       child: CourseCard(course: section),
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseSection course;
  const CourseCard({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(

                0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                child: const Icon(Icons.book, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                course.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                course.subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (!course.locked)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: course.progress,
                      backgroundColor: Colors.white24,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.completed
                          ? "Completed"
                          : "${(course.progress * 100).toInt()}% Progress",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (course.locked)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(Icons.lock, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class CourseSection {
  final String title;
  final String subtitle;
  final double progress;
  final bool locked;
  final bool completed;

  CourseSection({
    required this.title,
    required this.subtitle,
    this.progress = 0.0,
    this.locked = false,
    this.completed = false,
  });
}

class TopicListScreen extends StatefulWidget {
  final String title;
  final List<Map<String, String>> topics;
  const TopicListScreen({super.key, required this.title, required this.topics});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late List<bool> _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = List.generate(widget.topics.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CourseScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // handle notifications
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.topics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isCompleted[index] = !_isCompleted[index];
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LearningModuleScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white70,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  trailing: Icon(
                    _isCompleted[index] ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _isCompleted[index] ? Colors.greenAccent : Colors.deepPurpleAccent,
                    size: 30,
                  ),
                  title: Text(
                    widget.topics[index]['title']!,
                    style: TextStyle(
                      color: _isCompleted[index] ? Colors.greenAccent : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: _isCompleted[index] ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    widget.topics[index]['description']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white10,
                    radius: 18,
                    child: Icon(
                      topicIcons[index % topicIcons.length],
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final List<IconData> topicIcons = [
  Icons.info,
  Icons.widgets,
  Icons.settings,
  Icons.navigation,
  Icons.network_wifi,
  Icons.info,
  Icons.widgets,
  Icons.settings,
  Icons.navigation,
  Icons.network_wifi,
];

final List<Map<String, String>> beginnerTopics = [
  {'title': 'MyContainer', 'description': 'Basic widget for styling and positioning content'},
  {'title': 'MyExpanded', 'description': 'Expands a child to fill available space'},
  {'title': 'MyColumn', 'description': 'Arranges widgets vertically in a column'},
  {'title': 'MyRow', 'description': 'Arranges widgets horizontally in a row'},
  {'title': 'MyListView', 'description': 'Creates a scrollable list of widgets'},
  {'title': 'MySingleChildScrollView', 'description': 'Enables scrolling for a single child'},
  {'title': 'MyImageAsset', 'description': 'Loads and displays images from assets'},
  {'title': 'MyGridView', 'description': 'Displays widgets in a grid layout'},
  {'title': 'MyGestureDetector', 'description': 'Detects user gestures like taps and swipes'},
  {'title': 'MyBottomNavBar', 'description': 'Implements a bottom navigation bar'},
  {'title': 'MyAppBar', 'description': 'Creates a material design app bar'},
  {'title': 'MyDrawer', 'description': 'Implements a slide-out navigation drawer'},
  {'title': 'MySliverAppBar', 'description': 'Creates a collapsible app bar'},
  {'title': 'MyTabBar', 'description': 'Implements a tabbed interface'},
  {'title': 'MyAnimatedContainer', 'description': 'Animates container property changes'},
  {'title': 'MyMediaQuery', 'description': 'Adapts UI based on device properties'},
  {'title': 'MyAlertDialog', 'description': 'Shows a simple alert dialog'},
  {'title': 'MyTextStyle', 'description': 'Customizes text appearance'},
  {'title': 'MyRichText', 'description': 'Displays text with multiple styles'},
  {'title': 'MyTimer', 'description': 'Implements basic timer functionality'},
  {'title': 'MyPageView', 'description': 'Creates a swipeable page view'},
  {'title': 'MyStack', 'description': 'Layers widgets on top of each other'},
  {'title': 'MyTextField', 'description': 'Captures user text input'},
  {'title': 'MyAnimatedIcon', 'description': 'Animates icon transitions'},
  {'title': 'MySlider', 'description': 'Allows users to select a value from a range'},
  {'title': 'MyDatePicker', 'description': 'Displays a date selection dialog'},
  {'title': 'MyTimePicker', 'description': 'Displays a time selection dialog'},
  {'title': 'MyListWheelScrollView', 'description': 'Creates a 3D scrolling list'},
  {'title': 'MyLinearGradient', 'description': 'Applies linear gradient effects'},
  {'title': 'MyElevatedButton', 'description': 'Creates a raised material button'},
  {'title': 'MyFloatingActionButton', 'description': 'Implements a floating action button'},
  {'title': 'MyRawMaterialButton', 'description': 'Customizable material button'},
  {'title': 'MyIconButton', 'description': 'Creates a button with an icon'},
  {'title': 'MyNavigator', 'description': 'Manages app navigation'},
  {'title': 'MyCard', 'description': 'Creates a material design card'},
  {'title': 'MyCustomClipper', 'description': 'Defines custom clipping shapes'},
  {'title': 'MyRotatedBox', 'description': 'Rotates its child widget'},
  {'title': 'MyTransform', 'description': 'Applies transformations to widgets'},
  {'title': 'MyPositioned', 'description': 'Positions widgets within a Stack'},
  {'title': 'MyCustomPaint', 'description': 'Draws custom graphics'},
];

final List<Map<String, String>> intermediateTopics = [
  {'title': 'MyClipOval', 'description': 'Clips a widget into an oval shape'},
  {'title': 'MyClipRRect', 'description': 'Clips a widget with rounded corners'},
  {'title': 'MyClipRect', 'description': 'Clips a widget into a rectangle'},
  {'title': 'MyClipPath', 'description': 'Clips a widget with a custom path'},
  {'title': 'MyRadialGradient', 'description': 'Applies radial gradient effects'},
  {'title': 'MyStatefulWidget', 'description': 'Manages dynamic widget state'},
  {'title': 'MyTable', 'description': 'Creates a table layout'},
  {'title': 'MyDataTable', 'description': 'Displays data in a tabular format'},
  {'title': 'MyPlaceholder', 'description': 'Reserves space for future content'},
  {'title': 'MyGestureInk', 'description': 'Adds ink splash effects to gestures'},
  {'title': 'MyMaterial', 'description': 'Applies material design properties'},
  {'title': 'MySwitches', 'description': 'Implements toggle switches'},
  {'title': 'MyDropDownPopupMenu', 'description': 'Creates dropdown and popup menus'},
  {'title': 'MyHeroAnimation', 'description': 'Animates widgets between screens'},
  {'title': 'MyAboutDialog', 'description': 'Shows an about dialog for the app'},
  {'title': 'MyStepper', 'description': 'Creates a step-by-step interface'},
  {'title': 'MyFittedBox', 'description': 'Scales and positions a child widget'},
  {'title': 'MyShowSearch', 'description': 'Implements a search delegate'},
  {'title': 'MyAdaptive', 'description': 'Builds platform-adaptive layouts'},
  {'title': 'MyScrollbar', 'description': 'Adds a scrollbar to scrollable widgets'},
  {'title': 'MyChoiceChip', 'description': 'Creates selectable chip widgets'},
  {'title': 'MyWrap', 'description': 'Wraps widgets into multiple lines'},
  {'title': 'MyExpansionTile', 'description': 'Creates expandable list tiles'},
  {'title': 'MyRangeSlider', 'description': 'Selects a range of values'},
  {'title': 'MyShowModalBottomSheet', 'description': 'Displays a modal bottom sheet'},
  {'title': 'MyAnimatedCrossFade', 'description': 'Animates between two widgets'},
  {'title': 'MyFlexible', 'description': 'Controls flex layout behavior'},
  {'title': 'MySpacer', 'description': 'Creates flexible empty space'},
  {'title': 'MyGridPaper', 'description': 'Displays a grid background'},
  {'title': 'MyInteractiveViewer', 'description': 'Enables zooming and panning'},
  {'title': 'MyCheckboxListTile', 'description': 'Combines checkbox with list tile'},
  {'title': 'MySelectableText', 'description': 'Enables text selection'},
  {'title': 'MyAnimatedPadding', 'description': 'Animates padding changes'},
  {'title': 'MyRefreshIndicator', 'description': 'Implements pull-to-refresh'},
  {'title': 'MyImageFiltered', 'description': 'Applies image filters'},
  {'title': 'MyAspectRatio', 'description': 'Enforces a specific aspect ratio'},
  {'title': 'MyToggleButton', 'description': 'Creates toggleable buttons'},
  {'title': 'MyPhysicalModel', 'description': 'Applies physical layer effects'},
  {'title': 'MyAlign', 'description': 'Aligns a child widget'},
  {'title': 'MySafeArea', 'description': 'Avoids system UI intrusions'},
];

final List<Map<String, String>> advancedTopics = [
  {'title': 'MyPageRouteBuilder', 'description': 'Creates custom page transitions'},
  {'title': 'MyDraggable', 'description': 'Enables draggable widgets'},
  {'title': 'MyBackdropFilter', 'description': 'Applies blur effects'},
  {'title': 'MyReorderableListView', 'description': 'Creates reorderable lists'},
  {'title': 'MyFadeTransition', 'description': 'Animates widget opacity'},
  {'title': 'MyCircleAvatar', 'description': 'Displays circular avatars'},
  {'title': 'MyTooltip', 'description': 'Shows tooltips on long press'},
  {'title': 'MyVisibility', 'description': 'Controls widget visibility'},
  {'title': 'MyIndexedStack', 'description': 'Displays one child from a stack'},
  {'title': 'MyNavigator2', 'description': 'Implements advanced navigation'},
  {'title': 'MyInheritedWidget', 'description': 'Shares data down the widget tree'},
  {'title': 'MyFractionallySizedBox', 'description': 'Sizes widgets relative to parent'},
  {'title': 'MyConstrainedBox', 'description': 'Applies size constraints'},
  {'title': 'MyStatefulBuilder', 'description': 'Manages state in stateless widgets'},
  {'title': 'MyLayoutBuilder', 'description': 'Builds layouts based on constraints'},
  {'title': 'MyOrientationBuilder', 'description': 'Adapts to device orientation'},
  {'title': 'MyFutureBuilder', 'description': 'Handles asynchronous data'},
  {'title': 'MyStreamBuilder', 'description': 'Builds UI from stream data'},
  {'title': 'MyChangeNotifier', 'description': 'Manages state with notifications'},
  {'title': 'MyValueNotifier', 'description': 'Notifies listeners of value changes'},
  {'title': 'MyPageRouteBuilder', 'description': 'Creates custom page transitions'},
  {'title': 'MyDraggable', 'description': 'Enables draggable widgets'},
  {'title': 'MyBackdropFilter', 'description': 'Applies blur effects'},
  {'title': 'MyReorderableListView', 'description': 'Creates reorderable lists'},
  {'title': 'MyFadeTransition', 'description': 'Animates widget opacity'},
  {'title': 'MyCircleAvatar', 'description': 'Displays circular avatars'},
  {'title': 'MyTooltip', 'description': 'Shows tooltips on long press'},
  {'title': 'MyVisibility', 'description': 'Controls widget visibility'},
  {'title': 'MyIndexedStack', 'description': 'Displays one child from a stack'},
  {'title': 'MyNavigator2', 'description': 'Implements advanced navigation'},
  {'title': 'MyInheritedWidget', 'description': 'Shares data down the widget tree'},
  {'title': 'MyFractionallySizedBox', 'description': 'Sizes widgets relative to parent'},
  {'title': 'MyConstrainedBox', 'description': 'Applies size constraints'},
  {'title': 'MyStatefulBuilder', 'description': 'Manages state in stateless widgets'},
  {'title': 'MyLayoutBuilder', 'description': 'Builds layouts based on constraints'},
  {'title': 'MyOrientationBuilder', 'description': 'Adapts to device orientation'},
  {'title': 'MyFutureBuilder', 'description': 'Handles asynchronous data'},
  {'title': 'MyStreamBuilder', 'description': 'Builds UI from stream data'},
  {'title': 'MyChangeNotifier', 'description': 'Manages state with notifications'},
  {'title': 'MyValueNotifier', 'description': 'Notifies listeners of value changes'},
];

List<Map<String, String>> getTopicsByLevel(int level) {
  if (level >= 0 && level < 4) {
    return beginnerTopics.sublist(level * 10, (level + 1) * 10);
  } else if (level >= 4 && level < 8) {
    return intermediateTopics.sublist((level - 4) * 10, (level - 3) * 10);
  } else if (level >= 8 && level < 12) {
    return advancedTopics.sublist((level - 8) * 10, (level - 7) * 10);
  } else {
    return [];
  }
}

class BeginnerLevelScreen extends StatelessWidget {
  const BeginnerLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Beginner Fundamentals"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: CourseGrid(levelStart: 0, levelCount: 4),
      ),
    );
  }
}

class IntermediateLevelScreen extends StatelessWidget {
  const IntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Intermediate Mastery"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: CourseGrid(levelStart: 4, levelCount: 4),
      ),
    );
  }
}

class AdvancedLevelScreen extends StatelessWidget {
  const AdvancedLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Advanced Expertise"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: CourseGrid(levelStart: 8, levelCount: 4),
      ),
    );
  }
}

