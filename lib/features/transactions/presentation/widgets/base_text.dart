import 'package:flutter/material.dart';

class BaseText extends StatelessWidget {
  factory BaseText.displayLarge(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.displayLarge,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.displayMedium(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.displayMedium,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.displaySmall(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.displaySmall,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.headlineLarge(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.headlineLarge,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.headlineMedium(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.headlineMedium,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.headlineSmall(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.headlineSmall,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.titleLarge(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.titleLarge,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.titleMedium(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.titleMedium,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.titleSmall(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.titleSmall,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.bodyLarge(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.bodyLarge,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.bodyMedium(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.bodyMedium,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.bodySmall(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.bodySmall,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.labelLarge(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.labelLarge,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.labelMedium(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.labelMedium,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  factory BaseText.labelSmall(BuildContext context,
          {required String data,
          Color? color,
          int? maxLines,
          TextOverflow? overflow,
          TextAlign? textAlign}) =>
      BaseText._(
          data: data,
          style: Theme.of(context).textTheme.labelSmall,
          color: color,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);

  const BaseText._({
    required this.data,
    required this.style,
    this.color,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String data;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style?.copyWith(color: color),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
