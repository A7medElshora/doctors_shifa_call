import 'package:doctors_shifa_call/features/home/data/models/price/price_model.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/price/price_cubit.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/price/price_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';

class PriceScreen extends StatefulWidget {
  final String doctorId;

  const PriceScreen({super.key, required this.doctorId});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PriceCubit>().fetchPrices(widget.doctorId);
    });
  }

  void _showEditDialog(
    BuildContext context,
    String title,
    double initialValue,
    Function(double) onSave,
  ) {
    final controller = TextEditingController(text: initialValue.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تعديل $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: title,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text) ?? initialValue;
              onSave(value);
              Navigator.of(context).pop();
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          title: 'إدارة الأسعار',
          showBackInLeading: true,
          showBackButton: true,
          onBackPressed: () => Navigator.of(context).pop(),
          showBell: false,
          showUserIcon: false,
          showGridInLeading: false,
          backgroundColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocConsumer<PriceCubit, PriceState>(
            listener: (context, state) {
              if (state.status == PriceStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(state.errorMessage ?? 'فشل في جلب الأسعار')),
                );
              }
            },
            builder: (context, state) {
              if (state.status == PriceStatus.loading ||
                  state.priceModel == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final model = state.priceModel!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 80.h),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 3,
                      children: [
                        // السعر المصري أولاً
                        GestureDetector(
                          onTap: () => _showEditDialog(
                            context,
                            'سعر الكشف المصري',
                            model.onlinePrice,
                            (value) {
                              final updated = PriceModel(
                                id: model.id,
                                onlinePrice: value,
                                onlineUsdPrice: model.onlineUsdPrice,
                              );
                              context.read<PriceCubit>().updatePrices(updated);
                            },
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'سعر الكشف المصري',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.white),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'ج.م ${model.onlinePrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // السعر الأجنبي ثانياً
                        GestureDetector(
                          onTap: () => _showEditDialog(
                            context,
                            'سعر الكشف الأجنبي',
                            model.onlineUsdPrice,
                            (value) {
                              final updated = PriceModel(
                                id: model.id,
                                onlinePrice: model.onlinePrice,
                                onlineUsdPrice: value,
                              );
                              context.read<PriceCubit>().updatePrices(updated);
                            },
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'سعر الكشف الأجنبي',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.white),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'USD ${model.onlineUsdPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
