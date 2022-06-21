import 'package:flutter/material.dart';

class NotifierProvider<Model extends ChangeNotifier> extends StatefulWidget {
  const NotifierProvider({
    Key? key,
    required this.create,
    required this.child,
    this.isManagingModel = true,
  }) : super(key: key);

  final Model Function() create;
  final Widget child;
  final bool isManagingModel;

  static Model? of<Model extends ChangeNotifier>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheretedNotifierProvider<Model>>()
        ?.model;
  }

  @override
  State<NotifierProvider> createState() => _NotifierProviderState<Model>();
}

class _NotifierProviderState<Model extends ChangeNotifier>
    extends State<NotifierProvider<Model>> {
  late final Model _model;

  @override
  void initState() {
    super.initState();
    _model = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return _InheretedNotifierProvider<Model>(
      model: _model,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    if (widget.isManagingModel) _model.dispose();
    super.dispose();
  }
}

class _InheretedNotifierProvider<Model extends ChangeNotifier>
    extends InheritedNotifier {
  const _InheretedNotifierProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  final Model model;
}

class Provider<Model> extends InheritedWidget {
  const Provider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  final Model model;

  static Model? of<Model>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<Model>>()?.model;
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return model != oldWidget.model;
  }
}
