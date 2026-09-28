// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Rewire';

  @override
  String get appSubtitle => '脳を回復し、人生を取り戻す';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get reset => 'リセット';

  @override
  String get close => '閉じる';

  @override
  String get continueAction => '続ける';

  @override
  String get next => '次へ';

  @override
  String get skip => 'スキップ';

  @override
  String get startJourney => '旅を始める';

  @override
  String level(int level) {
    return 'レベル $level';
  }

  @override
  String days(int count) {
    return '$count 日';
  }

  @override
  String minutes(int count) {
    return '$count 分';
  }

  @override
  String dayCount(int day) {
    return '$day 日目';
  }

  @override
  String get navHome => 'ホーム';

  @override
  String get navMeditation => '瞑想';

  @override
  String get navWorkout => '運動';

  @override
  String get navProgress => '進捗';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get cleanStreakTitle => 'クリーン記録';

  @override
  String get relapseStreakTitle => 'リセット済み';

  @override
  String longestStreakSubtitle(int count) {
    return '最長記録: $count 日';
  }

  @override
  String get cleanTodayBanner => '今日もクリーンを維持しました！集中を続けましょう。';

  @override
  String get relapseTodayBanner => '今日スリップが記録されました。もう一度立ち上がりましょう！';

  @override
  String get checkinCta => 'チェックインする';

  @override
  String get alreadyCheckedIn => '本日のチェックイン完了';

  @override
  String get dailyQuestsTitle => 'デイリークエスト';

  @override
  String get quickActionsTitle => 'クイックアクション';

  @override
  String get quickMeditation => 'クイック瞑想';

  @override
  String get quickWorkout => 'クイック運動';

  @override
  String get emergencyUrge => '緊急パニックボタン';

  @override
  String get brainEvolutionTitle => '脳の進化';

  @override
  String get brainStageDormant => '休眠期 (初期段階)';

  @override
  String get brainStageAwakening => '覚醒 (兆し)';

  @override
  String get brainStageGrowing => '成長 (神経の強化)';

  @override
  String get brainStageThriving => '繁栄 (安定したネットワーク)';

  @override
  String get brainStageTranscendent => '超越 (リワイヤ完了)';

  @override
  String get checkinTitle => 'デイリーチェックイン';

  @override
  String get checkinSubtitle => '今日の調子はいかがですか？';

  @override
  String get checkinClean => 'クリーンな日';

  @override
  String get checkinCleanDesc => '今日はPMOなしで強く乗り切りました。';

  @override
  String get checkinRelapse => 'スリップした';

  @override
  String get checkinRelapseDesc => 'つまずきましたが、再スタートする準備はできています。';

  @override
  String get howAreYouFeeling => '気分はどうですか？';

  @override
  String get moodVeryBad => 'とても悪い';

  @override
  String get moodBad => '悪い';

  @override
  String get moodNeutral => '普通';

  @override
  String get moodGood => '良い';

  @override
  String get moodVeryGood => 'とても良い';

  @override
  String get triggersTitle => '今日の引き金（トリガー）は何でしたか？';

  @override
  String get notesTitle => 'メモ・振り返り';

  @override
  String get notesHint => '学んだことや感じたことを書き留めましょう...';

  @override
  String get submitCheckin => 'チェックインを保存';

  @override
  String get updateCheckin => 'チェックインを更新';

  @override
  String get meditationTitle => '瞑想ハブ';

  @override
  String get meditationSubtitle => '心を落ち着かせ、衝動をコントロールする';

  @override
  String get selectDuration => '時間を選択';

  @override
  String get soundscapeTitle => '環境音';

  @override
  String get breathingTechnique => '呼吸法';

  @override
  String get startMeditation => 'セッション開始';

  @override
  String get meditationComplete => 'セッション完了！';

  @override
  String get totalMeditationMinutes => '瞑想合計時間';

  @override
  String get workoutTitle => 'フィジカルトレーニング';

  @override
  String get workoutSubtitle => 'エネルギーを前向きな行動に向けよう';

  @override
  String get allRoutines => 'すべてのメニュー';

  @override
  String get startWorkout => 'トレーニング開始';

  @override
  String get workoutComplete => 'トレーニング完了！';

  @override
  String get totalWorkoutMinutes => 'トレーニング合計時間';

  @override
  String get progressTitle => '進捗と実績';

  @override
  String get streakSummary => '継続記録まとめ';

  @override
  String get achievementsTitle => '実績バッジ';

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total 解除済み';
  }

  @override
  String get profileTitle => 'プロフィールと設定';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get editName => '名前を変更';

  @override
  String get fullName => '氏名';

  @override
  String get physicalData => '身体データ';

  @override
  String get ageLabel => '年齢';

  @override
  String get heightLabel => '身長';

  @override
  String get weightLabel => '体重';

  @override
  String get appearanceSection => '外観';

  @override
  String get darkModeTitle => 'ダークモード';

  @override
  String get darkModeSubtitle => 'ダークテーマに切り替え';

  @override
  String get languageTitle => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get notificationsSection => '通知';

  @override
  String get dailyReminderTitle => '毎日のリマインダー';

  @override
  String get meditationReminderTitle => '瞑想リマインダー';

  @override
  String get workoutReminderTitle => '運動リマインダー';

  @override
  String get dataSection => 'データ';

  @override
  String get resetDataTitle => 'すべてのデータをリセット';

  @override
  String get resetDataConfirmTitle => 'すべてのデータをリセットしますか？';

  @override
  String get resetDataConfirmContent =>
      'この操作を行うと、すべての進捗、ストリーク、運動履歴が削除され、オンボーディング画面に戻ります。';

  @override
  String get aboutSection => 'アプリについて';

  @override
  String get appVersion => 'アプリバージョン';

  @override
  String get settingsTitle => '設定';

  @override
  String get reminderTimeTitle => 'リマインダー時間';

  @override
  String get editAction => '編集';

  @override
  String get yearsShort => '歳';

  @override
  String get editPhysicalDataTitle => 'プロフィールと身体データの編集';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get streakHistoryTitle => 'ストリーク履歴';

  @override
  String get last7Days => '過去7日間';

  @override
  String get noData => 'データなし';

  @override
  String get cleanTag => 'クリーン';

  @override
  String get relapseTag => 'リラップス';

  @override
  String get moodTrendTitle => '気分のトレンド';

  @override
  String get scale1To5 => '1〜5段階';

  @override
  String get noMoodHistory => '過去7日間の気分の記録はありません';

  @override
  String get mindStatsTitle => 'マインド統計';

  @override
  String get autoUpdated => '自動更新';

  @override
  String get currentStreakTitle => '現在のストリーク';

  @override
  String get longestStreakTitle => '最長ストリーク';

  @override
  String get totalCleanDays => 'クリーンな合計日数';

  @override
  String get totalMeditation => '合計瞑想時間';

  @override
  String get totalWorkoutSessions => '合計ワークアウト';

  @override
  String get totalXpAccumulated => '累計獲得';

  @override
  String sessionsCount(int count) {
    return '$count セッション';
  }

  @override
  String get weeklyChallengesTitle => '週間チャレンジ';

  @override
  String get calmMindTitle => '心を落ち着かせる';

  @override
  String get calmMindSubtitle => '今日の集中力を取り戻すために、雰囲気と瞑想時間を選びましょう。';

  @override
  String get durationTitle => '時間';

  @override
  String get focusTimeSubtitle => '集中時間';

  @override
  String get customDuration => 'カスタム ⏱️';

  @override
  String get routinesTitle => 'ルーティン';

  @override
  String get exercisesTitle => '種目';

  @override
  String get totalSessions => '合計セッション';

  @override
  String get totalMinutesLabel => '合計分';

  @override
  String get seeAll => 'すべて見る';

  @override
  String get allFilter => 'すべて';

  @override
  String get workoutXpRewardSubtitle => 'セッション完了ごとに+35 XP';

  @override
  String exercisesCount(int count) {
    return '$count 種目';
  }

  @override
  String get repsShort => '回';

  @override
  String get secondsShort => '秒';

  @override
  String get targetSet => '目標セット';

  @override
  String setsCount(int count) {
    return '$count セット';
  }

  @override
  String get durationPerSet => '時間 / セット';

  @override
  String get targetPerSet => '目標 / セット';

  @override
  String get targetMusclesTitle => '主な対象筋肉';

  @override
  String get instructionsTitle => '手順・解説';

  @override
  String get recoveryTipsTitle => '回復と姿勢のヒント';

  @override
  String get recoveryTipsContent =>
      '安定した呼吸と正確な動作に集中しましょう。急ぐよりもゆっくりと正確な動きの方が、脳の神経回路の再構築により効果的です。';

  @override
  String get timeBadge => '時間';

  @override
  String get cleanStreakActive => '継続中';

  @override
  String get streakStartFresh => '再スタート';

  @override
  String get cleanSubtitle => '気を散らさずにクリーン';

  @override
  String get recoverySubtitle => '回復の一歩';

  @override
  String get alreadyCheckedInToday => '本日は既にチェックイン済みです';

  @override
  String get alreadyCheckedInDesc =>
      '本日のチェックインは保存済みです。夜間に気分が変わったりスリップした場合でも、いつでも更新できます。';

  @override
  String get selectOne => '1つ選択';

  @override
  String get optionalLabel => '任意';

  @override
  String get triggersRelapseTitle => 'スリップの引き金は何でしたか？';

  @override
  String get notesEvaluationTitle => '振り返りノート（任意）';

  @override
  String get notesGratitudeTitle => '本日のメモと感謝（任意）';

  @override
  String get hintRelapseNotes => '引き金となった要因や学んだことを書き留めましょう...';

  @override
  String get hintCleanNotes => '今日クリーンを保てた要因や前向きな感謝を書きましょう...';

  @override
  String get checkinSuccessSaved => 'チェックインを保存しました！';

  @override
  String get checkinSuccessUpdated => 'チェックインを更新しました！';

  @override
  String get checkinEncourageTitle => '大丈夫です。';

  @override
  String get checkinEncourageDesc => '回復には時間がかかります。一番大切なのは、正直に向き合い再び立ち上がる勇気です。';

  @override
  String get checkinEncourageStreakNotice =>
      '連続記録はリセットされますが、総XPとレベルは完全に保持されます。';

  @override
  String get startAgainAction => '再スタート 💪';

  @override
  String get checkinBottomMotto => '脳の新しい神経回路を形成する小さな意識的な一歩。';

  @override
  String get unlockedBadge => '解除済み';

  @override
  String get lockedBadge => '未解除';

  @override
  String get noAchievementsYet => '実績データがまだありません';

  @override
  String get xpProgressTitle => 'XP 進捗';

  @override
  String xpToNextLevel(int xp, int nextLevel) {
    return 'レベル $nextLevel まであと $xp XP';
  }

  @override
  String get maxLevelReached => '最大レベル到達！🌟';

  @override
  String get cleanDayLegend => 'クリーンな日';

  @override
  String get relapseDayLegend => 'スリップした日';

  @override
  String get brainRewiringProgress => '脳の再構築の進捗';

  @override
  String maxLevelWithXp(int xp) {
    return '最大レベル ($xp XP)';
  }

  @override
  String get brainEvolutionStagesTitle => '脳の進化段階（神経可塑性）';

  @override
  String get freeBreathingTitle => '自由';

  @override
  String get naturalBreathingSubtitle => '自然';

  @override
  String get chooseSoundscapeSubtitle => '音を1つ選択';

  @override
  String get focusAndBreatheNaturally => '集中して自然に呼吸';
}
