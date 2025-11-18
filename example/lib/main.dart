import 'package:arabic_justified_text/arabic_justified_text.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Justified Text',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool enableKashida = true;
  double fontSize = 18.0;

  final String text1 =
      'في عالم التكنولوجيا الحديثة، أصبحت تطبيقات الهاتف المحمول جزءاً لا يتجزأ من حياتنا اليومية. فلاتر هو إطار عمل مفتوح المصدر من جوجل لبناء تطبيقات جميلة ومتعددة المنصات. يتميز فلاتر بسرعة الأداء وسهولة التطوير والقدرة على إنشاء واجهات مستخدم رائعة.';

  final String text2 =
      'Flutter هو framework رائع للتطوير. يمكنك بناء تطبيقات للـ Android والـ iOS باستخدام كود واحد. هذا يوفر الكثير من الوقت والجهد في عملية التطوير.';

  final String text3 =
      'البرمجة هي فن وعلم في نفس الوقت. تتطلب التفكير المنطقي والإبداع معاً.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محاذاة النص بالكشيدة'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // الإعدادات
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.settings, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'الإعدادات',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  SwitchListTile(
                    title: const Text('تفعيل الكشيدة'),
                    subtitle: const Text('استخدام ـ بدلاً من المسافات'),
                    value: enableKashida,
                    onChanged: (v) => setState(() => enableKashida = v),
                    activeThumbColor: Colors.green,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('حجم الخط', style: TextStyle(fontSize: 16)),
                      Text(
                        '${fontSize.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: fontSize,
                    min: 14,
                    max: 26,
                    divisions: 12,
                    onChanged: (v) => setState(() => fontSize = v),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // مثال 1
          _buildExample('✅ مع الكشيدة', text1, Colors.green, useKashida: true),

          const SizedBox(height: 16),

          // مثال 2
          _buildExample('❌ بدون الكشيدة', text1, Colors.red, useKashida: false),

          const SizedBox(height: 24),

          // مثال 3
          _buildExample('🌐 نص مختلط', text2, Colors.blue, useKashida: true),

          const SizedBox(height: 16),

          // مثال 4
          _buildExample('📝 نص قصير', text3, Colors.orange, useKashida: true),

          const SizedBox(height: 24),

          // ملاحظة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.shade300),
            ),
            child: Column(
              children: const [
                Icon(Icons.info_outline, color: Colors.purple, size: 32),
                SizedBox(height: 8),
                Text(
                  'الكشيدة (ـ) تجعل النص العربي أجمل',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'بدلاً من المسافات الكبيرة بين الكلمات',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(
    String title,
    String text,
    MaterialColor color, {
    required bool useKashida,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.shade300, width: 2),
          ),
          child: useKashida && enableKashida
              ? ArabicJustifiedText(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    height: 1.8,
                    color: Colors.black,
                  ),
                  enableKashida: true,
                )
              : Text(
                  text,
                  style: TextStyle(fontSize: fontSize, height: 1.8),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
        ),
      ],
    );
  }
}
