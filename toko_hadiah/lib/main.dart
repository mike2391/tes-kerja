import 'package:flutter/material.dart';
import 'package:toko_hadiah/service/api_service.dart';

//tesssss
class MenuItem {
  final String id;
  final String label;
  final IconData icon;

  MenuItem(this.id, this.label, this.icon);

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      json['CustID'].toString(),
      json['Name'] ?? '-',
      Icons.store,
    );
  }

  @override
  String toString() => label;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SafeArea(child: Scaffold(body: MainPage())),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<dynamic>> _futureCustomers;
  final TextEditingController menuController = TextEditingController();
  double dropdownWidth = 250;
  MenuItem? selectedMenu;

  Map<String, dynamic>? selectedCustomerDetail;
  List<String> ttotpList = [];

  @override
  void initState() {
    super.initState();
    _futureCustomers = ApiService.getCustomers();
  }

  Future<void> _loadCustomerDetail(String customerId) async {
    final data = await ApiService.getCustomerDetail(customerId);
    final status = await ApiService.getCustomerStatus(customerId);
    setState(() {
      selectedCustomerDetail = {
        "name": data["name"],
        "address": data["address"],
        "phone": data["phone"],
        "status": status,
      };
      ttotpList = List<String>.from(data["ttotpList"] ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _futureCustomers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final items = (snapshot.data ?? [])
                        .map<MenuItem>((json) => MenuItem.fromJson(json))
                        .toList();

                    return DropdownMenu<MenuItem>(
                      controller: menuController,
                      width: dropdownWidth,
                      hintText: "Cari toko",
                      requestFocusOnTap: true,
                      enableFilter: true,
                      label: const Text('Pilih Customer'),
                      onSelected: (MenuItem? menu) async {
                        if (menu == null) return;
                        setState(() {
                          selectedMenu = menu;
                        });
                        await _loadCustomerDetail(menu.id);
                      },
                      dropdownMenuEntries: items
                          .map<DropdownMenuEntry<MenuItem>>((MenuItem menu) {
                            return DropdownMenuEntry<MenuItem>(
                              value: menu,
                              label: menu.label,
                              leadingIcon: Icon(menu.icon),
                            );
                          })
                          .toList(),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: ApiService.getPrizeSummary(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const AlertDialog(
                              title: Text("Semua Hadiah"),
                              content: SizedBox(
                                height: 80,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: Text(snapshot.error.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tutup"),
                                ),
                              ],
                            );
                          }

                          final hadiahList = snapshot.data ?? [];
                          int total = hadiahList.fold(
                            0,
                            (sum, item) =>
                                sum +
                                (int.tryParse(item['total_qty'].toString()) ??
                                    0),
                          );

                          return AlertDialog(
                            title: const Text("Semua Hadiah"),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: hadiahList.length,
                                      itemBuilder: (context, index) {
                                        final hadiah = hadiahList[index];
                                        final jenis = hadiah['Jenis'] ?? "";
                                        final qty = hadiah['total_qty'] ?? 0;
                                        final unit = hadiah['Unit'] ?? "";
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.card_giftcard,
                                            color: Colors.red,
                                          ),
                                          title: Text(jenis.toString()),
                                          trailing: Text("$qty $unit"),
                                        );
                                      },
                                    ),
                                  ),
                                  const Divider(color: Colors.red),
                                  ListTile(
                                    title: const Text(
                                      "Total Hadiah",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      total.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Tutup"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: const Text("Semua Hadiah"),
              ),
            ],
          ),
        ),
        Expanded(
          child: selectedCustomerDetail == null
              ? const Center(child: Text("Silakan pilih customer"))
              : CustomerSection(
                  customer: selectedCustomerDetail!,
                  ttotpList: ttotpList,
                  onReceived: () {
                    setState(() {
                      selectedCustomerDetail!['received'] = 1;
                    });
                  },
                ),
        ),
      ],
    );
  }
}

class CustomerSection extends StatelessWidget {
  final Map<String, dynamic> customer;
  final List<String> ttotpList;
  final VoidCallback onReceived;

  const CustomerSection({
    super.key,
    required this.customer,
    required this.ttotpList,
    required this.onReceived,
  });
  void _showFailedDialog(BuildContext context, String code) {
    String? selectedReason;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Gagal terima TTH"),
              content: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Pilih alasan"),
                value: selectedReason,
                items: const [
                  DropdownMenuItem(value: "2", child: Text("Toko tutup")),
                  DropdownMenuItem(
                    value: "1",
                    child: Text("Pemilik toko tidak ada"),
                  ),
                ],
                onChanged: (val) {
                  setState(() {
                    selectedReason = val;
                  });
                },
              ),
              actions: [
                TextButton(
                  child: const Text("Batal"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("Simpan"),
                  onPressed: selectedReason == null
                      ? null
                      : () async {
                          Navigator.pop(context);
                          await ApiService.updateTTH(
                            tthNo: code,
                            received: 0,
                            failedReason: int.parse(selectedReason!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("TTH gagal diterima")),
                          );
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF00796B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer["name"] ?? "-",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            customer["address"] ?? "-",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    customer["status"] ?? "Belum Diberikan",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        customer["phone"] ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: ttotpList.length,
            itemBuilder: (context, index) {
              final code = ttotpList[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Sudah terima TTH?"),
                        actions: [
                          TextButton(
                            child: const Text("Tidak"),
                            onPressed: () {
                              Navigator.pop(context);
                              _showFailedDialog(context, code);
                            },
                          ),
                          TextButton(
                            child: const Text("Sudah Terima"),
                            onPressed: () async {
                              Navigator.pop(context);
                              await ApiService.updateTTH(
                                tthNo: code,
                                received: 1,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("TTH berhasil dikonfirmasi"),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },

                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(code, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
