import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://vwgnovrtpgvgwtqxrbuw.supabase.co',
    publishableKey: 'sb_publishable_hwP_GK_N8weFJJw00gW43A_-E0JREPb',
  );
  runApp(MyApp());
}