import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/modules/inventory/product_controller.dart';
import 'package:provider/provider.dart';
import '../general_platform/header_widget.dart';

class DashboadScreen extends StatefulWidget {
  @override
  _DashboadScreenState createState() => _DashboadScreenState();
}

class _DashboadScreenState extends State<DashboadScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<ProductController>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
        builder: (context, productController, _) {
      return Container(
        margin: AppResponsive.isDesktop(context) ? EdgeInsets.all(10) : null,
        padding: AppResponsive.isDesktop(context) ? EdgeInsets.all(10) : null,
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius: AppResponsive.isDesktop(context)
              ? BorderRadius.circular(30)
              : null,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(),
              ListTile(
                title: Text(
                  'Income and Expenses',
                ),
                subtitle: Text(
                  'Purpose: Provides a quick overview of your financial health.',
                ),
                trailing: Text(
                  'Integration: Include a section that shows total income and total expenses, with graphical representations such as bar charts or line graphs.',
                ),
              ),
              ListTile(
                title: Text(
                  'Accounts Receivable and Accounts Payable Balance',
                ),
                subtitle: Text(
                  'Purpose: Helps you keep track of money owed to you and money you owe.',
                ),
                trailing: Text(
                  'Integration:  Display current accounts receivable and accounts payable balances. Use charts to visualize trends over time.',
                ),
              ),
              ListTile(
                title: Text(
                  'Sales by Product',
                ),
                subtitle: Text(
                  'Purpose: Allows you to see which products are performing best.',
                ),
                trailing: Text(
                  'Integration:  Include a section that breaks down sales by product, showing top-selling products and sales trends.',
                ),
              ),
              ListTile(
                title: Text(
                  'Vendor Expenses',
                ),
                subtitle: Text(
                  'Purpose: Keeps track of expenses related to suppliers.',
                ),
                trailing: Text(
                  'Integration:  Display expenses incurred from suppliers. Include a list of top vendors by expense and visualize monthly vendor expenses.',
                ),
              ),
              ListTile(
                title: Text(
                  'Revenue',
                ),
                subtitle: Text(
                  'Purpose: Shows total revenue generated.',
                ),
                trailing: Text(
                  'Integration:  Include a section for total revenue, with comparisons to previous periods (e.g., month-over-month, year-over-year).',
                ),
              ),
              ListTile(
                title: Text(
                  'Expenses',
                ),
                subtitle: Text(
                  'Purpose: Shows total expenses incurred.',
                ),
                trailing: Text(
                  'Integration:  Display total expenses with breakdowns by category (e.g., marketing, salaries, rent).',
                ),
              ),
              ListTile(
                title: Text(
                  'Top Customers by Income',
                ),
                subtitle: Text(
                  'Purpose: Identifies your most valuable customers.',
                ),
                trailing: Text(
                  'Integration:  Include a section that lists top customers by revenue, showing customer details and purchase history.',
                ),
              ),
              Text(
                "Dashboard Layout: Main Dashboard Sections",
                style: TextStyle(color: Colors.grey),
              ),
              ListTile(
                title: Text(
                  'Financial Overview',
                ),
                subtitle: Text(
                  'Income and Expenses: Summary and comparison charts.',
                ),
                trailing: Text(
                  'Revenue and Expenses: Detailed charts showing trends over time.',
                ),
              ),
              ListTile(
                title: Text(
                  'Accounts Management',
                ),
                subtitle: Text(
                  'Accounts Receivable Balance: Current balance and aging summary.',
                ),
                trailing: Text(
                  'Accounts Payable Balance: Current balance and due dates.',
                ),
              ),
              ListTile(
                title: Text(
                  'Sales Insights',
                ),
                subtitle: Text(
                  'Sales by Product: Top-selling products and sales trends.',
                ),
                trailing: Text(
                  'Top Customers by Income: List of top customers with revenue details.',
                ),
              ),
              ListTile(
                title: Text(
                  'Vendor Management',
                ),
                subtitle: Text(
                  'Vendor Expenses: Breakdown of expenses by vendor and category.',
                ),
              ),
              Text(
                "Dashboard Layout: Additional Features",
                style: TextStyle(color: Colors.grey),
              ),
              ListTile(
                title: Text(
                  'Inventory Management',
                ),
                subtitle: Text(
                  'Stock Levels: Current stock levels of products.',
                ),
                trailing: Text(
                  'Reorder Alerts: Notifications for low-stock items.',
                ),
              ),
              ListTile(
                title: Text(
                  'Customer Management',
                ),
                subtitle: Text(
                  'Customer List: Overview of customer details and recent activity.',
                ),
                trailing: Text(
                  'Customer Feedback: Summary of customer reviews and ratings.',
                ),
              ),
              ListTile(
                title: Text(
                  'Supplier Management',
                ),
                subtitle: Text(
                  'Supplier List: Overview of supplier details and performance metrics.',
                ),
                trailing: Text(
                  'Order History: History of orders placed with suppliers.',
                ),
              ),
              ListTile(
                title: Text(
                  'Utilities',
                ),
                subtitle: Text(
                  'Reports: Generate financial, sales, and inventory reports.',
                ),
                trailing: Text(
                  'Settings: Configure system preferences and user permissions.',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
