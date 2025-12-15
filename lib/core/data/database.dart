import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Books table - stores book metadata
class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get title => text()();
  TextColumn get subtitle => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get purpose => text().nullable()(); // Learning purpose/goal
  BoolColumn get isTitleGenerated => boolean().withDefault(
    const Constant(false),
  )(); // Track if title is AI-generated
  TextColumn get coverPath => text().nullable()();
  TextColumn get genre => text().nullable()();
  TextColumn get status => text().withDefault(
    const Constant('draft'),
  )(); // draft, reading, completed
  TextColumn get parentBookId => text().nullable()(); // For derivatives
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Chapters table - stores chapter metadata
class Chapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get status => text().withDefault(
    const Constant('empty'),
  )(); // empty, draft, generated, reviewed
  IntColumn get orderIndex => integer()();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Bookmarks table - stores reading bookmarks
class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get chapterId =>
      integer().references(Chapters, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Notes table - stores margin notes
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get chapterId =>
      integer().references(Chapters, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Reading progress table - tracks reading position
class ReadingProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade).unique()();
  IntColumn get lastChapterId => integer().nullable().references(
    Chapters,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get lastPosition => integer().withDefault(const Constant(0))();
  RealColumn get percentComplete => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Books, Chapters, Bookmarks, Notes, ReadingProgress])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          // Drop the Highlights table
          await customStatement('DROP TABLE IF EXISTS highlights');
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'readforge_db');
  }
}
