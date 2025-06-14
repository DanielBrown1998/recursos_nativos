import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/account.dart';
import 'widgets/home_drawer.dart';
import 'widgets/account_widget.dart';
import 'widgets/add_account_modal.dart';
import 'view_model/home_viewmodel.dart';
import '../_core/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      viewModel.loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey,
        title: const Text("Sistema de gestão de contas"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "login");
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: const HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addAccountButtonClicked(context);
        },
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: viewModel.accounts.length,
                itemBuilder: (context, index) {
                  return AccountWidget(account: viewModel.accounts[index]);
                },
              ),
      ),
    );
  }

  Future<void> addAccountButtonClicked(BuildContext context) async {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    Account? account = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddAccountModal(),
    );

    if (account != null) {
      viewModel.addAccount(account);
    }
  }
}
