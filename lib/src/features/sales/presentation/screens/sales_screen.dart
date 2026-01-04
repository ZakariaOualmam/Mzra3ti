import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles.dart';
import '../../../../core/app_icons.dart';
import '../../../../shared/widgets/padded_fab.dart';
import '../../data/sales_repository.dart';
import '../../domain/sale.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> with SingleTickerProviderStateMixin {
  final _repo = SalesRepository();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog([Sale? existing]) async {
    final l10n = AppLocalizations.of(context)!;
    
    final nameController = TextEditingController(text: existing?.customerName ?? '');
    final phoneController = TextEditingController(text: existing?.customerPhone ?? '');
    final productController = TextEditingController(text: existing?.product ?? '');
    final quantityController = TextEditingController(text: existing?.quantity.toString() ?? '');
    final priceController = TextEditingController(text: existing?.pricePerUnit.toString() ?? '');
    
    DateTime date = existing?.date ?? DateTime.now();
    String paymentMethod = existing?.paymentMethod ?? 'Cash';
    String status = existing?.status ?? 'Paid';
    String? notes = existing?.notes;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final total = (double.tryParse(quantityController.text) ?? 0) *
                (double.tryParse(priceController.text) ?? 0);

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      existing == null ? l10n.addNewSale : l10n.editSale,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Customer Info Section
                          Text(
                            AppLocalizations.of(context)!.customerInfo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryGreen,
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.customerName,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.phoneNumber,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),

                          // Product Info Section
                          Text(
                            AppLocalizations.of(context)!.productInfo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryGreen,
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          TextField(
                            controller: productController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.product,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.inventory_2),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: quantityController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.quantity,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setDialogState(() {}),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: priceController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.pricePerUnit,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setDialogState(() {}),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          // Total Display
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppStyles.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppStyles.primaryGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${total.toStringAsFixed(2)} DH',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppStyles.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Payment & Status Section
                          Text(
                            AppLocalizations.of(context)!.paymentAndStatus,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryGreen,
                            ),
                          ),
                          SizedBox(height: 12),

                          // Payment Method
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: paymentMethod,
                                isExpanded: true,
                                items: ['Cash', 'Bank Transfer', 'Check'].map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Row(
                                      children: [
                                        Icon(_getPaymentIcon(method), size: 20),
                                        SizedBox(width: 12),
                                        Text(_getPaymentText(method)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setDialogState(() => paymentMethod = val!);
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Status
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: status,
                                isExpanded: true,
                                items: ['Paid', 'Pending', 'Partial'].map((st) {
                                  return DropdownMenuItem(
                                    value: st,
                                    child: Row(
                                      children: [
                                        Icon(_getStatusIcon(st), size: 20, color: _getStatusColor(st)),
                                        SizedBox(width: 12),
                                        Text(_getStatusText(st)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setDialogState(() => status = val!);
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Date Picker
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            leading: Icon(Icons.event_rounded, color: AppStyles.primaryGreen),
                            title: Text(AppLocalizations.of(context)!.dateLabel),
                            subtitle: Text(DateFormat('yyyy-MM-dd').format(date)),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setDialogState(() => date = picked);
                              }
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Save Button
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryGreen,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            productController.text.isEmpty ||
                            quantityController.text.isEmpty ||
                            priceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('الرجاء ملء جميع الحقول')),
                          );
                          return;
                        }

                        final sale = Sale(
                          id: existing?.id,
                          date: date,
                          customerName: nameController.text,
                          customerPhone: phoneController.text,
                          product: productController.text,
                          quantity: double.parse(quantityController.text),
                          pricePerUnit: double.parse(priceController.text),
                          totalAmount: total,
                          paymentMethod: paymentMethod,
                          status: status,
                          notes: notes,
                        );

                        if (existing == null) {
                          await _repo.add(sale);
                        } else {
                          await _repo.update(sale);
                        }

                        if (!mounted) return;
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                      child: Text(
                        l10n.save,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Cash':
        return Icons.money;
      case 'Bank Transfer':
        return Icons.account_balance;
      case 'Check':
        return Icons.receipt;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentText(String method) {
    switch (method) {
      case 'Cash':
        return AppLocalizations.of(context)!.cash;
      case 'Bank Transfer':
        return 'تحويل بنكي';
      case 'Check':
        return 'شيك';
      default:
        return method;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Paid':
        return Icons.check_circle;
      case 'Pending':
        return Icons.pending;
      case 'Partial':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Partial':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Paid':
        return AppLocalizations.of(context)!.paid;
      case 'Pending':
        return AppLocalizations.of(context)!.pending;
      case 'Partial':
        return AppLocalizations.of(context)!.partiallyPaid;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final green = AppStyles.primaryGreen;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: green,
        elevation: 3,
        shadowColor: green.withOpacity(0.5),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.sales,
          style: TextStyle(
            color: AppStyles.brandWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppStyles.brandIconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppStyles.brandWhite),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppStyles.brandWhite,
          labelColor: AppStyles.brandWhite,
          unselectedLabelColor: AppStyles.brandWhite.withOpacity(0.7),
          tabs: [
            Tab(text: AppLocalizations.of(context)!.sales),
            Tab(text: AppLocalizations.of(context)!.customers),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSalesList(),
          _buildCustomersList(),
        ],
      ),
      floatingActionButton: PaddedFab(
        child: FloatingActionButton(
          onPressed: _showAddDialog,
          backgroundColor: green,
          child: Icon(AppIcons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSalesList() {
    return FutureBuilder<List<Sale>>(
      future: _repo.list(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final sales = snapshot.data!;
        if (sales.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey.shade300),
                SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.noSales, style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Stats Card
            FutureBuilder<Map<String, dynamic>>(
              future: _repo.getStats(),
              builder: (context, statsSnapshot) {
                if (!statsSnapshot.hasData) return SizedBox();
                
                final stats = statsSnapshot.data!;
                return Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppStyles.primaryGreen, AppStyles.primaryGreen.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppStyles.primaryGreen.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('إجمالي', '${stats['totalSales'].toStringAsFixed(0)} DH', Icons.attach_money),
                      _buildStatItem(AppLocalizations.of(context)!.paid, '${stats['paidAmount'].toStringAsFixed(0)} DH', Icons.check_circle),
                      _buildStatItem(AppLocalizations.of(context)!.pending, '${stats['pendingAmount'].toStringAsFixed(0)} DH', Icons.pending),
                    ],
                  ),
                );
              },
            ),

            // Sales List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: sales.length,
                itemBuilder: (context, i) {
                  final sale = sales[i];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(sale.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getStatusIcon(sale.status),
                          color: _getStatusColor(sale.status),
                        ),
                      ),
                      title: Text(
                        sale.customerName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('${sale.product} × ${sale.quantity}'),
                          SizedBox(height: 2),
                          Text(
                            DateFormat('yyyy-MM-dd').format(sale.date),
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${sale.totalAmount.toStringAsFixed(0)} DH',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppStyles.primaryGreen,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _getStatusText(sale.status),
                            style: TextStyle(
                              fontSize: 11,
                              color: _getStatusColor(sale.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showAddDialog(sale),
                      onLongPress: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.deleteSale),
                            content: Text(AppLocalizations.of(context)!.confirmDeleteSale),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(AppLocalizations.of(context)!.cancelButton),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _repo.delete(sale.id!);
                          setState(() {});
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomersList() {
    return FutureBuilder<List<Customer>>(
      future: _repo.getCustomers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final customers = snapshot.data!;
        if (customers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
                SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.noCustomers, style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: customers.length,
          itemBuilder: (context, i) {
            final customer = customers[i];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: AppStyles.primaryGreen.withOpacity(0.1),
                  child: Text(
                    customer.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppStyles.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  customer.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(customer.phone),
                    SizedBox(height: 2),
                    Text(
                      '${customer.purchaseCount} عمليات شراء',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Text(
                  '${customer.totalPurchases.toStringAsFixed(0)} DH',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppStyles.primaryGreen,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
