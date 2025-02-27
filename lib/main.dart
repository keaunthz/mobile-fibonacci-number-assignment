import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FibonacciScreen(),
    );
  }
}

class FibonacciItem {
  final int number;
  final IconData icon;
  final int originalIndex;

  FibonacciItem(this.number, this.originalIndex) : icon = _getIcon(number);

  static IconData _getIcon(int num) {
    switch (num % 3) {
      case 0:
        return Icons.circle;
      case 1:
        return Icons.close;
      case 2:
        return Icons.square_outlined;
      default:
        return Icons.help;
    }
  }

  int get iconType => number % 3;
}

class FibonacciScreen extends StatefulWidget {
  const FibonacciScreen({super.key});

  @override
  State<FibonacciScreen> createState() => _FibonacciScreenState();
}

class _FibonacciScreenState extends State<FibonacciScreen> {
  List<FibonacciItem> fibonacciList = [];
  List<FibonacciItem> bottomSheetList = [];
  int? highlightedIndex;
  int? highlightedBottomSheetIndex;
  final ScrollController _fibonacciScrollController = ScrollController();
  final ScrollController _bottomSheetScrollController = ScrollController();
  int fetchCount = 40;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    generateFibonacci(fetchCount);
    _fibonacciScrollController.addListener(() {
      if (_fibonacciScrollController.position.pixels >=
              _fibonacciScrollController.position.maxScrollExtent - 50 &&
          !isLoading) {
        loadMoreData();
      }
    });
  }

  Future<void> loadMoreData() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    int newCount = fetchCount + 10;
    generateFibonacci(newCount);

    setState(() {
      fetchCount = newCount;
      isLoading = false;
    });
  }

  void generateFibonacci(int count) {
    List<int> temp = [0, 1];
    for (int i = 2; i < count; i++) {
      temp.add(temp[i - 1] + temp[i - 2]);
    }
    setState(() {
      fibonacciList = List.generate(
          temp.length, (index) => FibonacciItem(temp[index], index));
    });
  }

  void onTapNumber(int index) {
    setState(() {
      FibonacciItem tappedItem = fibonacciList.removeAt(index);
      bottomSheetList.add(tappedItem);

      bottomSheetList.sort((a, b) => a.number.compareTo(b.number));
      highlightedIndex = null;
      showBottomSheetWithType(tappedItem);
    });
  }

  void onTapBottomSheetItem(FibonacciItem item) {
    bottomSheetList.remove(item);
    fibonacciList.insert(item.originalIndex, item);
    highlightedBottomSheetIndex = item.originalIndex;
    Navigator.pop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_fibonacciScrollController.hasClients) {
        highlightedIndex = item.originalIndex;
        _fibonacciScrollController.animateTo(
          item.originalIndex * 50.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        setState(() {});
      }
    });
  }

  void showBottomSheetWithType(FibonacciItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateBottomSheet) {
          var filteredList = bottomSheetList
              .where((v) => v.iconType == item.iconType)
              .toList();

          highlightedBottomSheetIndex = filteredList
              .indexWhere((v) => v.originalIndex == item.originalIndex);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_bottomSheetScrollController.hasClients &&
                highlightedBottomSheetIndex! >= 0) {
              _bottomSheetScrollController
                  .jumpTo(highlightedBottomSheetIndex! * 50.0);
            }
          });

          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 300,
            child: ListView.builder(
              controller: _bottomSheetScrollController,
              itemCount: filteredList.length,
              itemBuilder: (context, i) {
                bool isHighlighted = (i == highlightedBottomSheetIndex);

                String displayNumber = "Number: ${filteredList[i].number}";
                String displayIndex = "Index: ${filteredList[i].originalIndex}";
                return ListTile(
                  trailing: Icon(filteredList[i].icon),
                  title: Text(displayNumber),
                  subtitle: Text(displayIndex),
                  tileColor: isHighlighted ? Colors.green.shade200 : null,
                  onTap: () {
                    setStateBottomSheet(() {
                      onTapBottomSheetItem(filteredList[i]);
                    });
                  },
                );
              },
            ),
          );
        });
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fibonacci List"),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _fibonacciScrollController,
        itemCount: fibonacciList.length + 1,
        itemBuilder: (context, index) {
          if (index == fibonacciList.length) {
            return isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          bool isHighlighted = (highlightedIndex == index);
          FibonacciItem item = fibonacciList[index];
          return ListTile(
            title: Text("Index: ${item.originalIndex} Number: ${item.number}",
                style: const TextStyle(fontSize: 16)),
            trailing: Icon(fibonacciList[index].icon),
            tileColor: isHighlighted ? Colors.red.shade200 : null,
            onTap: () => onTapNumber(index),
          );
        },
      ),
    );
  }
}
