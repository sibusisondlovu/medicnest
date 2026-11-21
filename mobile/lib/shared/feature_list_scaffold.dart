import 'package:flutter/material.dart';

/// Home layout shared by the doctor and patient sides. Caps content width so
/// it reads well on both phones and tablets.
class FeatureListScaffold extends StatelessWidget {
  const FeatureListScaffold({
    super.key,
    required this.title,
    required this.intro,
    required this.children,
  });

  final String title;
  final String intro;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(intro, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                for (final child in children) ...[
                  child,
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
