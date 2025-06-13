import 'package:flutter/material.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});
  @override
  _MindMapScreenState createState() => _MindMapScreenState();
}

class Node {
  String label;
  String shape;
  IconData icon;
  Color color;
  List<String> facts;
  List<Node> children;
  String? imageAsset;
  Offset position;

  Node(this.label,
      {this.shape = 'rectangle',
      this.icon = Icons.circle,
      this.color = Colors.pinkAccent,
      this.facts = const [],
      this.imageAsset,
      this.position = const Offset(0, 0)})
      : children = [];
}

class _MindMapScreenState extends State<MindMapScreen> {
  late Node animalRoot;
  final ScreenshotController _screenshotController = ScreenshotController();

  // Predefined colors to pick
  final List<Color> availableColors = [
    Colors.pinkAccent,
    Colors.lightGreenAccent,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.amber,
  ];

  // Predefined image assets for selection
  final List<String> availableImages = [
    'assets/animal.jpg',
    'assets/fish.jpg',
    'assets/bird.jpg',
    'assets/reptiles.jpg',
    'assets/frog.jpg',
    'assets/mammal.jpg',
    'assets/insect.jpg',
    // add more here if you want
  ];

  @override
  void initState() {
    super.initState();
    _initializeMindMap();
  }

  void _initializeMindMap() {
    animalRoot = Node("Animals",
        shape: 'rectangle',
        color: Colors.lightGreenAccent,
        imageAsset: 'assets/animal.jpg',
        position: Offset(620, 50));

    double spacing = 220;
    double startX = 50;
    double y = 250;

    animalRoot.children.addAll([
      Node("Fish",
          shape: 'rectangle',
          color: Colors.deepPurple[200]!,
          imageAsset: 'assets/fish.jpg',
          position: Offset(startX + spacing * 0, y),
          facts: [
            "Breathe underwater using gills",
            "Have scales and fins",
            "Cold-blooded",
            "Lay eggs"
          ]),
      Node("Birds",
          shape: 'rectangle',
          color: Colors.lightBlue[200]!,
          imageAsset: 'assets/bird.jpg',
          position: Offset(startX + spacing * 1, y),
          facts: ["Lay eggs", "Have feathers & wings", "Warm-blooded"]),
      Node("Reptiles",
          shape: 'rectangle',
          color: Colors.amber[300]!,
          imageAsset: 'assets/reptiles.jpg',
          position: Offset(startX + spacing * 2, y),
          facts: [
            "Cold-blooded",
            "Usually lay eggs",
            "Dry skin",
            "Have scales"
          ]),
      Node("Amphibians",
          shape: 'rectangle',
          color: Colors.orange[200]!,
          imageAsset: 'assets/frog.jpg',
          position: Offset(startX + spacing * 3, y),
          facts: [
            "Live on land and in water",
            "Cold-blooded",
            "Lay eggs",
            "Moist skin",
            "Webbed feet"
          ]),
      Node("Mammals",
          shape: 'rectangle',
          color: Colors.red[300]!,
          imageAsset: 'assets/mammal.jpg',
          position: Offset(startX + spacing * 4, y),
          facts: [
            "Nurse young with milk",
            "Have hair or fur",
            "Warm-blooded",
            "Give birth to young"
          ]),
      Node("Insects",
          shape: 'rectangle',
          color: Colors.yellow[300]!,
          imageAsset: 'assets/insect.jpg',
          position: Offset(startX + spacing * 5, y),
          facts: [
            "Have six legs",
            "Usually have wings",
            "Cold-blooded",
            "Lay eggs"
          ]),
    ]);
  }

  void _editNode(Node node) async {
    final labelCtrl = TextEditingController(text: node.label);
    final factCtrl = TextEditingController();
    String selectedShape = node.shape;
    Color selectedColor = node.color;
    String? selectedImage = node.imageAsset;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text("Edit Node"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                TextField(
                    controller: labelCtrl,
                    decoration: InputDecoration(labelText: 'Label')),
                SizedBox(height: 10),
                // Shape selector
                Row(
                  children: [
                    Text("Shape: "),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedShape,
                      items: ['rectangle', 'circle', 'round']
                          .map((shape) => DropdownMenuItem(
                                value: shape,
                                child: Text(shape),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setStateDialog(() {
                            selectedShape = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Color picker
                Row(
                  children: [
                    Text("Color: "),
                    SizedBox(width: 10),
                    Wrap(
                      spacing: 8,
                      children: availableColors
                          .map((color) => GestureDetector(
                                onTap: () {
                                  setStateDialog(() {
                                    selectedColor = color;
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: selectedColor == color
                                        ? Border.all(
                                            color: Colors.black, width: 2)
                                        : null,
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
                SizedBox(height: 10),
                // Image picker
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Image: "),
                    SizedBox(width: 10),
                    DropdownButton<String?>(
                      value: selectedImage,
                      hint: Text("None"),
                      items: [null, ...availableImages]
                          .map((img) => DropdownMenuItem<String?>(
                                value: img,
                                child: Text(img == null
                                    ? "None"
                                    : img.split('/').last),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          selectedImage = val;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                // Facts list
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Facts:",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                ...node.facts
                    .asMap()
                    .entries
                    .map((entry) => Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              initialValue: entry.value,
                              onChanged: (newVal) {
                                node.facts[entry.key] = newVal;
                              },
                            )),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setStateDialog(() {
                                  node.facts.removeAt(entry.key);
                                });
                              },
                            )
                          ],
                        ))
                    ,
                SizedBox(height: 10),
                // Add new fact
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: factCtrl,
                        decoration:
                            InputDecoration(labelText: 'Add new fact'),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (factCtrl.text.trim().isNotEmpty) {
                            setStateDialog(() {
                              node.facts.add(factCtrl.text.trim());
                              factCtrl.clear();
                            });
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            if (node != animalRoot)
              TextButton(
                onPressed: () {
                  setState(() {
                    animalRoot.children.remove(node);
                  });
                  Navigator.pop(context);
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            TextButton(
                onPressed: () {
                  setState(() {
                    node.label = labelCtrl.text;
                    node.shape = selectedShape;
                    node.color = selectedColor;
                    node.imageAsset = selectedImage;
                  });
                  Navigator.pop(context);
                },
                child: Text("Save")),
          ],
        ),
      ),
    );
  }

 void _addNode() async {
  final labelCtrl = TextEditingController(text: 'New Node');
  final factCtrl = TextEditingController();
  String selectedShape = 'round';
  Color selectedColor = availableColors.first;
  String? selectedImage;

  List<String> tempFacts = [];

  await showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setStateDialog) => AlertDialog(
        title: Text("Add New Node"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label
              TextField(
                controller: labelCtrl,
                decoration: InputDecoration(labelText: 'Label'),
              ),
              SizedBox(height: 10),

              // Shape selector
              Row(
                children: [
                  Text("Shape: "),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedShape,
                    items: ['rectangle', 'circle', 'round']
                        .map((shape) => DropdownMenuItem(
                              value: shape,
                              child: Text(shape),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setStateDialog(() {
                          selectedShape = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Color picker
              Row(
                children: [
                  Text("Color: "),
                  SizedBox(width: 10),
                  Wrap(
                    spacing: 8,
                    children: availableColors
                        .map((color) => GestureDetector(
                              onTap: () {
                                setStateDialog(() {
                                  selectedColor = color;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selectedColor == color
                                      ? Border.all(color: Colors.black, width: 2)
                                      : null,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
              SizedBox(height: 10),

              // Image picker
              Row(
                children: [
                  Text("Image: "),
                  SizedBox(width: 10),
                  DropdownButton<String?>(
                    value: selectedImage,
                    hint: Text("None"),
                    items: [null, ...availableImages]
                        .map((img) => DropdownMenuItem<String?>(
                              value: img,
                              child: Text(img == null ? "None" : img.split('/').last),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedImage = val;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // Facts section
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Facts:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...tempFacts
                  .asMap()
                  .entries
                  .map((entry) => Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: entry.value,
                              onChanged: (newVal) {
                                tempFacts[entry.key] = newVal;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setStateDialog(() {
                                tempFacts.removeAt(entry.key);
                              });
                            },
                          )
                        ],
                      ))
                  ,
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: factCtrl,
                      decoration: InputDecoration(labelText: 'Add new fact'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (factCtrl.text.trim().isNotEmpty) {
                        setStateDialog(() {
                          tempFacts.add(factCtrl.text.trim());
                          factCtrl.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newNode = Node(
                labelCtrl.text.trim(),
                shape: selectedShape,
                color: selectedColor,
                imageAsset: selectedImage,
                facts: tempFacts,
                position: Offset(100, 400),
              );

              setState(() {
                animalRoot.children.add(newNode);
              });

              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    ),
  );
}



  Future<void> _saveAsImage() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      await Printing.sharePdf(bytes: image, filename: 'mind_map.png');
    }
  }

  Future<void> _saveAsPdf() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final pdf = pw.Document();
      final imageProvider = pw.MemoryImage(image);
      pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Image(imageProvider))));
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'mind_map.pdf');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodes = [animalRoot, ...animalRoot.children];
    final nodeWidgets = nodes.map((node) => _buildDraggableNode(node)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mind Map"),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/putih1.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                CustomPaint(
                  painter: DoodleArrowPainter(animalRoot),
                  size: Size.infinite,
                ),
                ...nodeWidgets,
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn_edit",
                  onPressed: () => _editNode(animalRoot),
                  child: Icon(Icons.edit),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_add",
                  onPressed: _addNode,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_image",
                  onPressed: _saveAsImage,
                  child: Icon(Icons.image),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_pdf",
                  onPressed: _saveAsPdf,
                  child: Icon(Icons.picture_as_pdf),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableNode(Node node) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: Draggable(
        data: node,
        feedback: Material(
          color: Colors.transparent,
          child: _nodeBox(node),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: _nodeBox(node)),
        onDragEnd: (details) {
          setState(() {
            final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
            node.position = Offset(details.offset.dx, details.offset.dy - appBarHeight);
          });
        },
        child: GestureDetector(
          onTap: () => _editNode(node),
          child: _nodeBox(node),
        ),
      ),
    );
  }

  Widget _nodeBox(Node node) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(node.icon, color: node.color, size: 24),
            SizedBox(width: 8),
            Text(node.label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ],
        ),
        if (node.imageAsset != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Image.asset(node.imageAsset!, height: 40),
          ),
        for (var fact in node.facts)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text("• $fact",
                style: TextStyle(fontSize: 12, color: Colors.grey[800])),
          )
      ],
    );

    BoxDecoration decoration;

    switch (node.shape) {
      case 'circle':
        decoration = BoxDecoration(
          color: node.color.withOpacity(0.3),
          border: Border.all(color: node.color, width: 2),
          shape: BoxShape.circle,
        );
        content = Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: content),
        );
        break;
      case 'round':
        decoration = BoxDecoration(
          color: node.color.withOpacity(0.3),
          border: Border.all(color: node.color, width: 2),
          borderRadius: BorderRadius.circular(100), // big radius for roundish cloud shape
        );
        content = Padding(
          padding: const EdgeInsets.all(16),
          child: content,
        );
        break;
      case 'rectangle':
      default:
        decoration = BoxDecoration(
          color: node.color.withOpacity(0.3),
          border: Border.all(color: node.color, width: 2),
          borderRadius: BorderRadius.circular(16),
        );
        content = Padding(
          padding: const EdgeInsets.all(12),
          child: content,
        );
        break;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.all(8),
        width: 250,
        decoration: decoration,
        child: content,
      ),
    );
  }
}

class DoodleArrowPainter extends CustomPainter {
  final Node root;
  DoodleArrowPainter(this.root);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var child in root.children) {
      final start = Offset(root.position.dx + 125, root.position.dy + 80);
      final end = Offset(child.position.dx + 125, child.position.dy);
      final path = Path();
      path.moveTo(start.dx, start.dy);
      final midX = (start.dx + end.dx) / 2;
      final control1 = Offset(midX, start.dy + 30);
      final control2 = Offset(midX, end.dy - 30);
      path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
      _drawArrowhead(canvas, paint, end, control2);
    }
  }

  void _drawArrowhead(Canvas canvas, Paint paint, Offset tip, Offset from) {
    final angle = (tip - from).direction;
    const size = 10.0;
    final path = Path();
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx - size * cos(angle - pi / 6), tip.dy - size * sin(angle - pi / 6));
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(tip.dx - size * cos(angle + pi / 6), tip.dy - size * sin(angle + pi / 6));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


