import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox verticalSpace(int height) => SizedBox(height: height.h);

SizedBox horizontalSpace(int width) => SizedBox(width: width.w);

SliverToBoxAdapter sliverVerticalSpace(int height) => SliverToBoxAdapter(
      child: SizedBox(height: height.h),
    );

SliverToBoxAdapter sliverHorzintoalSpace(int width) => SliverToBoxAdapter(
      child: SizedBox(width: width.w),
    );
