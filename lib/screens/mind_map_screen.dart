import 'package:flutter/material.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// THEME COLORS
final Color themePrimary = Colors.deepOrangeAccent;
final Color themeBackground = const Color(0xFFFFF5E1);
final Color themeAccent = const Color(0xFF8B4513);

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
      Color? color,
      this.facts = const [],
      this.imageAsset,
      this.position = const Offset(0, 0)})
      : color = color ?? themePrimary,
        children = [];
}

class _MindMapScreenState extends State<MindMapScreen> {
  late Node animalRoot;
  final ScreenshotController _screenshotController = ScreenshotController();

  // Predefined colors to pick
  final List<Color> availableColors = [
    themePrimary,
    Colors.orangeAccent,
    Colors.brown[200]!,
    Colors.amber[300]!,
    themeAccent,
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
  animalRoot = Node("Animal",
      shape: 'rectangle',
      color: Colors.orangeAccent,
      imageAsset: 'assets/animal.jpg',
      position: const Offset(450, 30)); // naikkan juga posisi root

  double spacing = 150; // dikurangkan supaya lebih padat
  double startX = 50;
  double y = 180; // dinaikkan supaya tidak tutup butang bawah

  animalRoot.children.addAll([
    Node("Fish",
        shape: 'rectangle',
        color: const Color(0xFFB5EAD7), // pastel green
        imageAsset: 'assets/fish.jpg',
        position: Offset(startX + spacing * 0, y),
        facts: [
          "Breathe in water using gills",
          "Have scales and fins",
          "Cold-blooded",
          "Lay eggs"
        ]),
    Node("Bird",
        shape: 'rectangle',
        color: const Color(0xFFFFDAC1), // pastel peach
        imageAsset: 'assets/bird.jpg',
        position: Offset(startX + spacing * 1, y),
        facts: ["Lay eggs", "Have feathers & wings", "Warm-blooded"]),
    Node("Reptile",
        shape: 'rectangle',
        color: const Color(0xFFFFB7B2), // pastel pink
        imageAsset: 'assets/reptiles.jpg',
        position: Offset(startX + spacing * 2, y),
        facts: [
          "Cold-blooded",
          "Usually lay eggs",
          "Dry skin",
          "Have scales"
        ]),
    Node("Amphibian",
        shape: 'rectangle',
        color: const Color(0xFFA7C7E7), // pastel blue
        imageAsset: 'assets/frog.jpg',
        position: Offset(startX + spacing * 3, y),
        facts: [
          "Live on land and in water",
          "Cold-blooded",
          "Lay eggs",
          "Moist skin",
          "Webbed feet"
        ]),
    Node("Mammal",
        shape: 'rectangle',
        color: const Color(0xFFF7D6E0), // pastel lavender
        imageAsset: 'assets/mammal.jpg',
        position: Offset(startX + spacing * 4, y),
        facts: [
          "Feed their young with milk",
          "Have fur or hair",
          "Warm-blooded",
          "Give birth to live young"
        ]),
    Node("Insect",
        shape: 'rectangle',
        color: const Color(0xFFFFF5BA), // pastel yellow
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
          backgroundColor: Colors.white,
          title: Text("Edit Node",
              style: const TextStyle(
                  fontFamily: 'AlfaSlabOne',
                  color: Colors.deepOrangeAccent)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                TextField(
                    controller: labelCtrl,
                    decoration: const InputDecoration(labelText: 'Label'),
                    style: const TextStyle(fontFamily: 'AlfaSlabOne')),
                const SizedBox(height: 10),
                // Shape selector
                Row(
                  children: [
                    const Text("Shape: ",
                        style: TextStyle(fontFamily: 'AlfaSlabOne')),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedShape,
                      items: ['rectangle', 'circle', 'round']
                          .map((shape) => DropdownMenuItem(
                                value: shape,
                                child: Text(shape,
                                    style: const TextStyle(
                                        fontFamily: 'AlfaSlabOne')),
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
                const SizedBox(height: 10),
                // Color picker
                Row(
                  children: [
                    const Text("Color: ",
                        style: TextStyle(fontFamily: 'AlfaSlabOne')),
                    const SizedBox(width: 10),
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
                                            color: themeAccent, width: 2)
                                        : null,
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                // Image picker
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Image: ",
                        style: TextStyle(fontFamily: 'AlfaSlabOne')),
                    const SizedBox(width: 10),
                    DropdownButton<String?>(
                      value: selectedImage,
                      hint: const Text("None",
                          style: TextStyle(fontFamily: 'AlfaSlabOne')),
                      items: [null, ...availableImages]
                          .map((img) => DropdownMenuItem<String?>(
                                value: img,
                                child: Text(
                                    img == null
                                        ? "None"
                                        : img.split('/').last,
                                    style: const TextStyle(
                                        fontFamily: 'AlfaSlabOne')),
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
                const SizedBox(height: 10),
                const Divider(),
                // Facts list
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Facts:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AlfaSlabOne'))),
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
                              style: const TextStyle(
                                  fontFamily: 'AlfaSlabOne', fontSize: 13),
                            )),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setStateDialog(() {
                                  node.facts.removeAt(entry.key);
                                });
                              },
                            )
                          ],
                        )),
                const SizedBox(height: 10),
                // Add new fact
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: factCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Add fact'),
                        style: const TextStyle(fontFamily: 'AlfaSlabOne'),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.add),
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
                child: const Text("Delete",
                    style: TextStyle(
                        color: Colors.red, fontFamily: 'AlfaSlabOne')),
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
                child: const Text("Save",
                    style: TextStyle(fontFamily: 'AlfaSlabOne'))),
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
          backgroundColor: Colors.white,
          title: const Text("Add New Node",
              style: TextStyle(
                  fontFamily: 'AlfaSlabOne', color: Colors.deepOrangeAccent)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                TextField(
                  controller: labelCtrl,
                  decoration: const InputDecoration(labelText: 'Label'),
                  style: const TextStyle(fontFamily: 'AlfaSlabOne'),
                ),
                const SizedBox(height: 10),

                // Shape selector
                Row(
                  children: [
                    const Text("Shape: ",
                        style: TextStyle(fontFamily: 'AlfaSlabOne')),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedShape,
                      items: ['rectangle', 'circle', 'round']
                          .map((shape) => DropdownMenuItem(
                                value: shape,
                                child: Text(shape,
                                    style: const TextStyle(
                                        fontFamily: 'AlfaSlabOne')),
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
                const SizedBox(height: 10),

                // Color picker
                Row(
                  children: [
                    const Text("Color: ",
                        style: TextStyle(fontFamily: 'AlfaSlabOne')),
                    const SizedBox(width: 10),
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
                                            color: themeAccent, width: 2)
                                        : null,
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // Image picker
                Row(
                  children: [
                    const Text("Image: ",
                        style: TextStyle(fontFamily: 'AlfaSlabOne')),
                    const SizedBox(width: 10),
                    DropdownButton<String?>(
                      value: selectedImage,
                      hint: const Text("None",
                          style: TextStyle(fontFamily: 'AlfaSlabOne')),
                      items: [null, ...availableImages]
                          .map((img) => DropdownMenuItem<String?>(
                                value: img,
                                child: Text(
                                    img == null
                                        ? "None"
                                        : img.split('/').last,
                                    style: const TextStyle(
                                        fontFamily: 'AlfaSlabOne')),
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
                const SizedBox(height: 10),
                const Divider(),

                // Facts section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Facts:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AlfaSlabOne')),
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
                                style: const TextStyle(
                                    fontFamily: 'AlfaSlabOne', fontSize: 13),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setStateDialog(() {
                                  tempFacts.removeAt(entry.key);
                                });
                              },
                            )
                          ],
                        )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: factCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Add fact'),
                        style: const TextStyle(fontFamily: 'AlfaSlabOne'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
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
              child: const Text("Cancel",
                  style: TextStyle(fontFamily: 'AlfaSlabOne')),
            ),
            TextButton(
              onPressed: () {
                final newNode = Node(
                  labelCtrl.text.trim(),
                  shape: selectedShape,
                  color: selectedColor,
                  imageAsset: selectedImage,
                  facts: tempFacts,
                  position: const Offset(100, 400),
                );

                setState(() {
                  animalRoot.children.add(newNode);
                });

                Navigator.pop(context);
              },
              child: const Text("Add",
                  style: TextStyle(fontFamily: 'AlfaSlabOne')),
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
      pdf.addPage(
          pw.Page(build: (context) => pw.Center(child: pw.Image(imageProvider))));
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'mind_map.pdf');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodes = [animalRoot, ...animalRoot.children];
    final nodeWidgets = nodes.map((node) => _buildDraggableNode(node)).toList();

    return Scaffold(
      backgroundColor: themeBackground,
      appBar: AppBar(
        title: const Text("Mind Map",
            style: TextStyle(
                fontFamily: 'AlfaSlabOne', color: Colors.white, fontSize: 22)),
        backgroundColor: themePrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  backgroundColor: Colors.white,
                  onPressed: () => _editNode(animalRoot),
                  child: const Icon(Icons.edit, color: Colors.deepOrangeAccent),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_add",
                  backgroundColor: Colors.white,
                  onPressed: _addNode,
                  child: const Icon(Icons.add, color: Colors.deepOrangeAccent),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_image",
                  backgroundColor: Colors.white,
                  onPressed: _saveAsImage,
                  child: const Icon(Icons.image, color: Colors.deepOrangeAccent),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btn_pdf",
                  backgroundColor: Colors.white,
                  onPressed: _saveAsPdf,
                  child: const Icon(Icons.picture_as_pdf, color: Colors.deepOrangeAccent),
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
            final appBarHeight =
                AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
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
            const SizedBox(width: 8),
            Flexible(
              child: Text(node.label,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AlfaSlabOne',
                      color: Colors.black)),
            )
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
                style: TextStyle(
                    fontSize: 13,
                    color: themeAccent,
                    fontFamily: 'AlfaSlabOne')),
          )
      ],
    );

    BoxDecoration decoration;

    switch (node.shape) {
      case 'circle':
        decoration = BoxDecoration(
          color: node.color.withOpacity(0.25),
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
          color: node.color.withOpacity(0.22),
          border: Border.all(color: node.color, width: 2),
          borderRadius: BorderRadius.circular(100),
        );
        content = Padding(
          padding: const EdgeInsets.all(16),
          child: content,
        );
        break;
      case 'rectangle':
      default:
        decoration = BoxDecoration(
          color: node.color.withOpacity(0.18),
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
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
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
      ..color = themeAccent
      ..strokeWidth = 2.5
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
