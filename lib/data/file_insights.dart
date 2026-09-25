/// One page inside the preview carousel on File Details.
class PreviewPage {
  final String title;
  final String subtitle;
  final List<String> bullets;
  final bool hasDiagram;

  const PreviewPage({
    required this.title,
    required this.subtitle,
    required this.bullets,
    this.hasDiagram = false,
  });
}

/// One file's AI Summary block and preview pages. Controlled data for the
/// browser demo; a live model lands in a later branch.
class FileInsight {
  final String summary;
  final List<String> themes;
  final int? pageCount;
  final List<PreviewPage> pages;

  const FileInsight({
    required this.summary,
    required this.themes,
    required this.pages,
    this.pageCount,
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
    pages: [
      PreviewPage(
        title: 'DATABASE SYSTEMS',
        subtitle: 'Lecture 3 - Relational Model',
        bullets: ['Table Structure', 'Keys and Relationships', 'SQL Basics'],
        hasDiagram: true,
      ),
      PreviewPage(
        title: 'DATABASE SYSTEMS',
        subtitle: 'Lecture 3 - Normalization',
        bullets: ['1NF', '2NF', '3NF'],
      ),
      PreviewPage(
        title: 'DATABASE SYSTEMS',
        subtitle: 'Lecture 3 - SQL Queries',
        bullets: ['SELECT', 'JOIN', 'Aggregates'],
      ),
    ],
  ),
  'f2': FileInsight(
    summary:
        'Slides for the group presentation on computer networks. Covers the '
        'OSI model, TCP/IP stack, and a case study on campus Wi-Fi.',
    themes: ['OSI Model', 'TCP/IP', 'Wi-Fi', 'Case Study'],
    pageCount: 18,
    pages: [
      PreviewPage(
        title: 'COMPUTER NETWORKS',
        subtitle: 'Group Presentation',
        bullets: [
          'Layered Architecture',
          'Packet Routing',
          'Wireless Protocols',
        ],
      ),
      PreviewPage(
        title: 'COMPUTER NETWORKS',
        subtitle: 'Case Study - Campus Wi-Fi',
        bullets: ['Coverage Maps', 'Load Balancing', 'Observations'],
      ),
    ],
  ),
  'f3': FileInsight(
    summary:
        'Final paper on software engineering practices. Argues for test-'
        'driven development in student projects and reviews three case '
        'studies.',
    themes: ['TDD', 'Case Studies', 'Best Practices'],
    pageCount: 12,
    pages: [
      PreviewPage(
        title: 'SOFTWARE ENGINEERING',
        subtitle: 'Final Paper',
        bullets: ['Abstract', 'Literature Review', 'Methodology', 'Findings'],
      ),
    ],
  ),
  'f4': FileInsight(
    summary:
        'One-page formula sheet for the calculus final. Includes derivatives, '
        'integrals, and trig identities.',
    themes: ['Derivatives', 'Integrals', 'Trigonometry'],
    pageCount: 1,
    pages: [
      PreviewPage(
        title: 'CALCULUS',
        subtitle: 'Formula Reference Sheet',
        bullets: ['Power Rule', 'Chain Rule', 'Integration by Parts'],
      ),
    ],
  ),
  'f5': FileInsight(
    summary:
        'Lab report for week 7 on digital circuits. Includes circuit '
        'schematics, measured voltages, and a comparison against simulation.',
    themes: ['Logic Gates', 'Measurements', 'Simulation'],
    pageCount: 8,
    pages: [
      PreviewPage(
        title: 'DIGITAL CIRCUITS',
        subtitle: 'Lab Report - Week 7',
        bullets: ['Objectives', 'Circuit Diagrams', 'Results and Discussion'],
      ),
    ],
  ),
  'f8': FileInsight(
    summary:
        'Lecture notes covering operating systems scheduling. Compares FCFS, '
        'SJF, and Round Robin with worked examples.',
    themes: ['FCFS', 'SJF', 'Round Robin'],
    pageCount: 20,
    pages: [
      PreviewPage(
        title: 'OPERATING SYSTEMS',
        subtitle: 'Lecture 4 - Scheduling',
        bullets: [
          'Process States',
          'Scheduling Algorithms',
          'Performance Metrics',
        ],
      ),
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
    pages: [
      PreviewPage(
        title: fileType,
        subtitle: fileName,
        bullets: const ['Preview not available for this file type yet.'],
      ),
    ],
  );
}
