/// One file's AI Summary block and preview content. Controlled data for the
/// browser demo; a live model lands in a later branch.
class FileInsight {
  final String summary;
  final List<String> themes;
  final int? pageCount;
  final String previewTitle;
  final String previewSubtitle;
  final List<String> previewBullets;
  final bool previewHasDiagram;

  const FileInsight({
    required this.summary,
    required this.themes,
    required this.previewTitle,
    required this.previewSubtitle,
    required this.previewBullets,
    this.pageCount,
    this.previewHasDiagram = false,
  });
}

const Map<String, FileInsight> kFileInsights = {
  'f1': FileInsight(
    summary:
        'A lecture note covering Data Systems. Key topics include the '
        'relational model, normalization (1NF to 3NF), SQL queries, and '
        'practice exercises.',
    themes: ['Relational Model', 'Normalization', 'SQL', 'Exercises'],
    pageCount: 24,
    previewTitle: 'DATABASE SYSTEMS',
    previewSubtitle: 'Lecture 3 - Relational Model',
    previewBullets: ['Table Structure', 'Keys and Relationships', 'SQL Basics'],
    previewHasDiagram: true,
  ),
  'f2': FileInsight(
    summary:
        'Slides for the group presentation on computer networks. Covers the '
        'OSI model, TCP/IP stack, and a case study on campus Wi-Fi.',
    themes: ['OSI Model', 'TCP/IP', 'Wi-Fi', 'Case Study'],
    pageCount: 18,
    previewTitle: 'COMPUTER NETWORKS',
    previewSubtitle: 'Group Presentation',
    previewBullets: [
      'Layered Architecture',
      'Packet Routing',
      'Wireless Protocols',
    ],
  ),
  'f3': FileInsight(
    summary:
        'Final paper on software engineering practices. Argues for test-'
        'driven development in student projects and reviews three case '
        'studies.',
    themes: ['TDD', 'Case Studies', 'Best Practices'],
    pageCount: 12,
    previewTitle: 'SOFTWARE ENGINEERING',
    previewSubtitle: 'Final Paper',
    previewBullets: [
      'Abstract',
      'Literature Review',
      'Methodology',
      'Findings',
    ],
  ),
  'f4': FileInsight(
    summary:
        'One-page formula sheet for the calculus final. Includes derivatives, '
        'integrals, and trig identities.',
    themes: ['Derivatives', 'Integrals', 'Trigonometry'],
    pageCount: 1,
    previewTitle: 'CALCULUS',
    previewSubtitle: 'Formula Reference Sheet',
    previewBullets: ['Power Rule', 'Chain Rule', 'Integration by Parts'],
  ),
  'f5': FileInsight(
    summary:
        'Lab report for week 7 on digital circuits. Includes circuit '
        'schematics, measured voltages, and a comparison against simulation.',
    themes: ['Logic Gates', 'Measurements', 'Simulation'],
    pageCount: 8,
    previewTitle: 'DIGITAL CIRCUITS',
    previewSubtitle: 'Lab Report - Week 7',
    previewBullets: [
      'Objectives',
      'Circuit Diagrams',
      'Results and Discussion',
    ],
  ),
  'f8': FileInsight(
    summary:
        'Lecture notes covering operating systems scheduling. Compares FCFS, '
        'SJF, and Round Robin with worked examples.',
    themes: ['FCFS', 'SJF', 'Round Robin'],
    pageCount: 20,
    previewTitle: 'OPERATING SYSTEMS',
    previewSubtitle: 'Lecture 4 - Scheduling',
    previewBullets: [
      'Process States',
      'Scheduling Algorithms',
      'Performance Metrics',
    ],
  ),
};

/// Returns an insight for a file. Uses a per-type fallback when the file is
/// not in the map, so every file the user opens has something to show.
FileInsight insightFor(String fileId, String fileName, String fileType) {
  final known = kFileInsights[fileId];
  if (known != null) return known;

  return FileInsight(
    summary:
        '$fileName is a $fileType file. Its contents can be read aloud to '
        'you or opened to view the original.',
    themes: [fileType, 'No preview available'],
    previewTitle: fileType,
    previewSubtitle: fileName,
    previewBullets: const ['Preview not available for this file type yet.'],
  );
}
