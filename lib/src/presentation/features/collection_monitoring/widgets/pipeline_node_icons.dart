import 'package:fluent_ui/fluent_ui.dart';

import '../../../../domain/entities/pipeline_trace_graph.dart';

IconData pipelineNodeIconData(String nodeId) {
  switch (pipelineNodeIconKey(nodeId)) {
    case 'field':
      return FluentIcons.map_pin;
    case 'capture':
      return FluentIcons.camera;
    case 'download':
      return FluentIcons.download;
    case 'shield':
      return FluentIcons.shield;
    case 'check_receive':
      return FluentIcons.check_mark;
    case 'save':
      return FluentIcons.save;
    case 'document':
      return FluentIcons.document;
    case 'link':
      return FluentIcons.link;
    case 'duplicate':
      return FluentIcons.branch_compare;
    case 'processing':
      return FluentIcons.processing_run;
    case 'settings':
      return FluentIcons.settings;
    case 'clock':
      return FluentIcons.clock;
    case 'report':
      return FluentIcons.report_document;
    case 'normalize':
      return FluentIcons.switch_widget;
    case 'waveform':
      return FluentIcons.analytics_view;
    case 'place':
      return FluentIcons.timeline;
    case 'tool':
      return FluentIcons.developer_tools;
    case 'embed':
      return FluentIcons.database;
    case 'search':
      return FluentIcons.search;
    case 'archive':
      return FluentIcons.archive;
    default:
      return FluentIcons.circle_ring;
  }
}
