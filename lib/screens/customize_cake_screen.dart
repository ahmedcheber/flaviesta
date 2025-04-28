import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CustomizeCakeScreen extends StatefulWidget {
  const CustomizeCakeScreen({super.key});

  @override
  State<CustomizeCakeScreen> createState() => _CustomizeCakeScreenState();
}

class _CustomizeCakeScreenState extends State<CustomizeCakeScreen>
    with TickerProviderStateMixin {
  final List<Offset> _toppingOffsets = [];
  final List<Widget> _placedToppings = [];
  double _totalPrice = 15.0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Offset? _lastPosition;
  Widget? _lastTopping;
  late AnimationController _animationController;
  late Animation<double> _animation;

  String? _selectedShape;
  String? _selectedFlavor;
  Color _cakeColor = const Color.fromRGBO(251, 221, 210, 1); // default color

  final List<Map<String, dynamic>> toppings = [
    {'label': '🍓', 'price': 1.5},
    {'label': '🍫', 'price': 2.0},
    {'label': '🍒', 'price': 1.0},
    {'label': '🫐', 'price': 1.2},
  ];

  final List<Map<String, dynamic>> cakeShapes = [
    {'shape': 'Round', 'icon': Icons.circle},
    {'shape': 'Square', 'icon': Icons.crop_square},
    {'shape': 'Heart', 'icon': Icons.favorite},
    {'shape': 'Hexagon', 'icon': Icons.hexagon},
  ];

  final List<Map<String, dynamic>> cakeFlavors = [
    {'flavor': 'Vanilla', 'color': Color(0xFFFFF0B3)},  // light yellow
    {'flavor': 'Chocolate', 'color': Color(0xFF8B4513)}, // brown
    {'flavor': 'Strawberry', 'color': Color(0xFFFFC0CB)}, // pink
    {'flavor': 'Blueberry', 'color': Color(0xFFADD8E6)}, // light blue
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  void _addTopping(Offset position, String label, double price) async {
    final topping = Positioned(
      left: position.dx - 20,
      top: position.dy - 80,
      child: ScaleTransition(
        scale: _animation,
        child: Text(label, style: const TextStyle(fontSize: 32)),
      ),
    );
    setState(() {
      _placedToppings.add(topping);
      _toppingOffsets.add(position);
      _totalPrice += price;
      _lastPosition = position;
      _lastTopping = topping;
    });
    _animationController.forward(from: 0);
    await _audioPlayer.play(AssetSource('audio/ding.mp3'));
  }

  void _undoLastTopping() {
    if (_placedToppings.isNotEmpty) {
      setState(() {
        final last = _placedToppings.removeLast();
        final index = _placedToppings.length;
        _toppingOffsets.removeAt(index);
        _totalPrice -= toppings[index % toppings.length]['price'];
      });
    }
  }

  void _selectFlavor(Map<String, dynamic> flavorData) {
    setState(() {
      _selectedFlavor = flavorData['flavor'];
      _cakeColor = flavorData['color'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  title: const Text('Customize Your Cake'),
  backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
  actions: [
    IconButton(
      icon: const Icon(Icons.undo),
      onPressed: _undoLastTopping,
      tooltip: 'Undo Topping',
    ),
    IconButton(
      icon: const Icon(Icons.change_circle),
      onPressed: () {
        setState(() {
          _selectedShape = null; // Revenir pour choisir la forme
        });
      },
      tooltip: 'Change Shape',
    ),
  ],
)
    );

  }

  Widget _buildShapeSelector() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Choose your cake shape",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: cakeShapes.map((shape) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedShape = shape['shape'];
                  });
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(251, 221, 210, 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    shape['icon'],
                    size: 50,
                    color: Colors.brown,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizer() {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(
                    child: _buildCakeShape(),
                  ),
                  ..._placedToppings,
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Flavor: ${_selectedFlavor ?? "Choose"}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: cakeFlavors.map((flavor) {
                return ChoiceChip(
                  label: Text(flavor['flavor']),
                  selected: _selectedFlavor == flavor['flavor'],
                  selectedColor: flavor['color'],
                  onSelected: (bool selected) {
                    _selectFlavor(flavor);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Total: \$${_totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 114, 88, 65),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: toppings.map((topping) {
                return Draggable<Map<String, dynamic>>(
                  data: topping,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Text(topping['label'], style: const TextStyle(fontSize: 32)),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.4,
                    child: Text(topping['label'], style: const TextStyle(fontSize: 32)),
                  ),
                  child: Text(topping['label'], style: const TextStyle(fontSize: 32)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
                foregroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        Positioned.fill(
          child: DragTarget<Map<String, dynamic>>(
            onAcceptWithDetails: (details) {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final localOffset = renderBox.globalToLocal(details.offset);
              _addTopping(localOffset, details.data['label'], details.data['price']);
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                color: Colors.transparent,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCakeShape() {
    switch (_selectedShape) {
      case 'Round':
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: _cakeColor,
            shape: BoxShape.circle,
          ),
        );
      case 'Square':
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: _cakeColor,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      case 'Heart':
        return Icon(
          Icons.favorite,
          color: _cakeColor,
          size: 200,
        );
      case 'Hexagon':
        return Container(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: HexagonPainter(cakeColor: _cakeColor),
          ),
        );
      default:
        return Container();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class HexagonPainter extends CustomPainter {
  final Color cakeColor;

  HexagonPainter({required this.cakeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cakeColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;
    path.moveTo(width * 0.5, 0);
    path.lineTo(width, height * 0.25);
    path.lineTo(width, height * 0.75);
    path.lineTo(width * 0.5, height);
    path.lineTo(0, height * 0.75);
    path.lineTo(0, height * 0.25);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
