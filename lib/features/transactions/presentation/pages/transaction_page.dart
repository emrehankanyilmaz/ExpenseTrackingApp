// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/transaction_provider.dart';
// import '../providers/category_provider.dart';

// class TransactionsPage extends StatelessWidget {
//   const TransactionsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final transactionProvider = context.watch<TransactionProvider>();
//     final categoryProvider = context.watch<CategoryProvider>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Tüm İşlemler',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: transactionProvider.transactions.isEmpty
//           ? const Center(
//               child: Text('Henüz işlem yok',
//                   style: TextStyle(color: Colors.grey, fontSize: 16)),
//             )
//           : ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: transactionProvider.transactions.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 8),
//               itemBuilder: (_, index) {
//                 final t = transactionProvider.transactions[index];
//                 final category = categoryProvider.getCategoryById(t.categoryId);
//                 return Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 44,
//                         height: 44,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(category?.icon ?? '💰',
//                               style: const TextStyle(fontSize: 22)),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               category?.name ?? 'Bilinmiyor',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                             if (t.description.isNotEmpty)
//                               Text(
//                                 t.description,
//                                 style: const TextStyle(
//                                     color: Colors.grey, fontSize: 12),
//                               ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             '${t.type == 0 ? '- ' : ''}₺ ${t.amount.toStringAsFixed(0)}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                               color: t.type == 0 ? Colors.red : Colors.green,
//                             ),
//                           ),
//                           Text(
//                             '${t.transactionDate.day} ${_monthName(t.transactionDate.month)} ${t.transactionDate.year}',
//                             style: const TextStyle(
//                                 color: Colors.grey, fontSize: 11),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
