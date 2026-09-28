// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Rewire';

  @override
  String get appSubtitle => 'Restaura tu mente y toma el control de tu vida';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get reset => 'Restablecer';

  @override
  String get close => 'Cerrar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Saltar';

  @override
  String get startJourney => 'Comenzar Viaje';

  @override
  String level(int level) {
    return 'Nivel $level';
  }

  @override
  String days(int count) {
    return '$count Días';
  }

  @override
  String minutes(int count) {
    return '$count Minutos';
  }

  @override
  String dayCount(int day) {
    return 'Día $day';
  }

  @override
  String get navHome => 'Inicio';

  @override
  String get navMeditation => 'Meditación';

  @override
  String get navWorkout => 'Ejercicio';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navProfile => 'Perfil';

  @override
  String get cleanStreakTitle => 'Racha Limpia';

  @override
  String get relapseStreakTitle => 'Racha Reiniciada';

  @override
  String longestStreakSubtitle(int count) {
    return 'Más larga: $count Días';
  }

  @override
  String get cleanTodayBanner =>
      '¡Te mantuviste limpio hoy! Mantén el enfoque.';

  @override
  String get relapseTodayBanner =>
      'Recaída registrada hoy. ¡Levántate de nuevo!';

  @override
  String get checkinCta => 'Registrar Ahora';

  @override
  String get alreadyCheckedIn => 'Ya registrado hoy';

  @override
  String get dailyQuestsTitle => 'Misiones Diarias';

  @override
  String get quickActionsTitle => 'Acciones Rápidas';

  @override
  String get quickMeditation => 'Meditación Rápida';

  @override
  String get quickWorkout => 'Ejercicio Rápido';

  @override
  String get emergencyUrge => 'Botón de Pánico';

  @override
  String get brainEvolutionTitle => 'Evolución Cerebral';

  @override
  String get brainStageDormant => 'Latente (Fase Inicial)';

  @override
  String get brainStageAwakening => 'Despertar (Primeros Pasos)';

  @override
  String get brainStageGrowing => 'Crecimiento (Fortalecimiento)';

  @override
  String get brainStageThriving => 'Prosperidad (Red Fuerte)';

  @override
  String get brainStageTranscendent => 'Trascendente (Reconectado)';

  @override
  String get checkinTitle => 'Registro Diario';

  @override
  String get checkinSubtitle => '¿Cómo fue tu día?';

  @override
  String get checkinClean => 'Día Limpio';

  @override
  String get checkinCleanDesc => 'Me mantuve fuerte sin PMO el día de hoy.';

  @override
  String get checkinRelapse => 'Tuve una Recaída';

  @override
  String get checkinRelapseDesc =>
      'Tropecé hoy, pero estoy listo para levantarme.';

  @override
  String get howAreYouFeeling => '¿Cómo te sientes?';

  @override
  String get moodVeryBad => 'Muy Mal';

  @override
  String get moodBad => 'Mal';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodGood => 'Bien';

  @override
  String get moodVeryGood => 'Muy Bien';

  @override
  String get triggersTitle => '¿Cuáles fueron los desencadenantes de hoy?';

  @override
  String get notesTitle => 'Notas y Reflexiones';

  @override
  String get notesHint => 'Escribe lo que aprendiste o cómo te sientes...';

  @override
  String get submitCheckin => 'Guardar Registro';

  @override
  String get updateCheckin => 'Actualizar Registro';

  @override
  String get meditationTitle => 'Centro de Meditación';

  @override
  String get meditationSubtitle => 'Calma tu mente y domina tus impulsos';

  @override
  String get selectDuration => 'Seleccionar Duración';

  @override
  String get soundscapeTitle => 'Sonido Ambiental';

  @override
  String get breathingTechnique => 'Técnica de Respiración';

  @override
  String get startMeditation => 'Comenzar Sesión';

  @override
  String get meditationComplete => '¡Sesión Completada!';

  @override
  String get totalMeditationMinutes => 'Total de Meditación';

  @override
  String get workoutTitle => 'Entrenamiento Físico';

  @override
  String get workoutSubtitle => 'Canaliza tu energía en acciones positivas';

  @override
  String get allRoutines => 'Todas las Rutinas';

  @override
  String get startWorkout => 'Comenzar Entrenamiento';

  @override
  String get workoutComplete => '¡Entrenamiento Completado!';

  @override
  String get totalWorkoutMinutes => 'Total de Entrenamiento';

  @override
  String get progressTitle => 'Progreso y Logros';

  @override
  String get streakSummary => 'Resumen de Rachas';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked de $total Desbloqueados';
  }

  @override
  String get profileTitle => 'Perfil y Ajustes';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get editName => 'Cambiar Nombre';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get physicalData => 'DATOS FÍSICOS';

  @override
  String get ageLabel => 'Edad';

  @override
  String get heightLabel => 'Altura';

  @override
  String get weightLabel => 'Peso';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get darkModeTitle => 'Modo Oscuro';

  @override
  String get darkModeSubtitle => 'Cambiar a tema oscuro';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get notificationsSection => 'Notificaciones';

  @override
  String get dailyReminderTitle => 'Recordatorio Diario';

  @override
  String get meditationReminderTitle => 'Recordatorio de Meditación';

  @override
  String get workoutReminderTitle => 'Recordatorio de Ejercicio';

  @override
  String get dataSection => 'Datos';

  @override
  String get resetDataTitle => 'Restablecer Todos los Datos';

  @override
  String get resetDataConfirmTitle => '¿Restablecer Todos los Datos?';

  @override
  String get resetDataConfirmContent =>
      'Esta acción eliminará permanentemente todo tu progreso, rachas e historial. Volverás a la pantalla de bienvenida.';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get appVersion => 'Versión de la Aplicación';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get reminderTimeTitle => 'Hora del Recordatorio';

  @override
  String get editAction => 'Editar';

  @override
  String get yearsShort => 'años';

  @override
  String get editPhysicalDataTitle => 'Editar Perfil y Datos Físicos';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get streakHistoryTitle => 'Historial de Rachas';

  @override
  String get last7Days => 'Últimos 7 Días';

  @override
  String get noData => 'Sin datos';

  @override
  String get cleanTag => 'Limpio';

  @override
  String get relapseTag => 'Recaída';

  @override
  String get moodTrendTitle => 'Tendencia del Estado de Ánimo';

  @override
  String get scale1To5 => 'Escala 1 - 5';

  @override
  String get noMoodHistory => 'Sin registros de ánimo en los últimos 7 días';

  @override
  String get mindStatsTitle => 'Estadísticas Mentales';

  @override
  String get autoUpdated => 'Actualización automática';

  @override
  String get currentStreakTitle => 'Racha Actual';

  @override
  String get longestStreakTitle => 'Racha Más Larga';

  @override
  String get totalCleanDays => 'Total de Días Limpios';

  @override
  String get totalMeditation => 'Total Meditación';

  @override
  String get totalWorkoutSessions => 'Total Entrenamiento';

  @override
  String get totalXpAccumulated => 'Total Acumulado';

  @override
  String sessionsCount(int count) {
    return '$count Sesiones';
  }

  @override
  String get weeklyChallengesTitle => 'Desafíos Semanales';

  @override
  String get calmMindTitle => 'Calma Tu Mente';

  @override
  String get calmMindSubtitle =>
      'Elige tu ambiente y duración para recuperar el enfoque hoy.';

  @override
  String get durationTitle => 'Duración';

  @override
  String get focusTimeSubtitle => 'Tiempo de enfoque';

  @override
  String get customDuration => 'Personalizado ⏱️';

  @override
  String get routinesTitle => 'Rutinas';

  @override
  String get exercisesTitle => 'Ejercicios';

  @override
  String get totalSessions => 'Total Sesiones';

  @override
  String get totalMinutesLabel => 'Total Minutos';

  @override
  String get seeAll => 'Ver Todo';

  @override
  String get allFilter => 'Todos';

  @override
  String get workoutXpRewardSubtitle => '+35 XP por sesión completada';

  @override
  String exercisesCount(int count) {
    return '$count Ejercicios';
  }

  @override
  String get repsShort => 'Reps';

  @override
  String get secondsShort => 's';

  @override
  String get targetSet => 'Series objetivo';

  @override
  String setsCount(int count) {
    return '$count Series';
  }

  @override
  String get durationPerSet => 'Duración / Serie';

  @override
  String get targetPerSet => 'Objetivo / Serie';

  @override
  String get targetMusclesTitle => 'Músculos principales';

  @override
  String get instructionsTitle => 'Instrucciones';

  @override
  String get recoveryTipsTitle => 'Consejos de recuperación y postura';

  @override
  String get recoveryTipsContent =>
      'Concéntrate en la respiración constante y el control de cada repetición. Los movimientos lentos y precisos reconectan las vías neuronales con mayor eficacia que la rapidez.';

  @override
  String get timeBadge => 'Tiempo';

  @override
  String get cleanStreakActive => 'Racha Activa';

  @override
  String get streakStartFresh => 'Nuevo Comienzo';

  @override
  String get cleanSubtitle => 'limpio sin distracciones';

  @override
  String get recoverySubtitle => 'paso de recuperación';

  @override
  String get alreadyCheckedInToday => 'Ya te has registrado hoy';

  @override
  String get alreadyCheckedInDesc =>
      'El registro de hoy ha sido guardado. Puedes actualizar los datos en cualquier momento si la situación cambia por la noche.';

  @override
  String get selectOne => 'Selecciona uno';

  @override
  String get optionalLabel => 'Opcional';

  @override
  String get triggersRelapseTitle => '¿Qué provocó la recaída?';

  @override
  String get notesEvaluationTitle => 'Notas de evaluación (Opcional)';

  @override
  String get notesGratitudeTitle => 'Notas y gratitud de hoy (Opcional)';

  @override
  String get hintRelapseNotes =>
      'Escribe qué provocó la recaída o qué lección aprendiste...';

  @override
  String get hintCleanNotes =>
      'Escribe reflexiones positivas o agradecimientos que te ayudaron...';

  @override
  String get checkinSuccessSaved => '¡Registro guardado con éxito!';

  @override
  String get checkinSuccessUpdated => '¡Registro actualizado con éxito!';

  @override
  String get checkinEncourageTitle => 'Está bien.';

  @override
  String get checkinEncourageDesc =>
      'Todo proceso toma tiempo. Lo más importante es tu honestidad y valor para volver a levantarte.';

  @override
  String get checkinEncourageStreakNotice =>
      'Tu racha se reiniciará, pero tu XP total y nivel se mantendrán intactos.';

  @override
  String get startAgainAction => 'Empezar de nuevo 💪';

  @override
  String get checkinBottomMotto =>
      'Un pequeño paso consciente para forjar nuevas vías neuronales.';

  @override
  String get unlockedBadge => 'Desbloqueado';

  @override
  String get lockedBadge => 'Bloqueado';

  @override
  String get noAchievementsYet => 'Aún no hay datos de logros';

  @override
  String get xpProgressTitle => 'Progreso de XP';

  @override
  String xpToNextLevel(int xp, int nextLevel) {
    return '$xp XP más para el Nivel $nextLevel';
  }

  @override
  String get maxLevelReached => '¡Nivel máximo alcanzado! 🌟';

  @override
  String get cleanDayLegend => 'Día limpio';

  @override
  String get relapseDayLegend => 'Día de recaída';

  @override
  String get brainRewiringProgress => 'Progreso de Reconexión Cerebral';

  @override
  String maxLevelWithXp(int xp) {
    return 'Nivel Máximo ($xp XP)';
  }

  @override
  String get brainEvolutionStagesTitle =>
      'Etapas de Evolución Cerebral (Neuroplasticidad)';

  @override
  String get freeBreathingTitle => 'Libre';

  @override
  String get naturalBreathingSubtitle => 'Natural';

  @override
  String get chooseSoundscapeSubtitle => 'Elige 1 ambiente';

  @override
  String get focusAndBreatheNaturally => 'Enfoque y respiración natural';

  @override
  String get cancelWorkoutTitle => '¿Cancelar entrenamiento?';

  @override
  String get cancelWorkoutMessage =>
      'El progreso de esta sesión no se guardará si sales ahora.';

  @override
  String get continueWorkout => 'Continuar entrenamiento';

  @override
  String get yesCancel => 'Sí, cancelar';

  @override
  String exerciseProgress(int current, int total) {
    return 'Ejercicio $current / $total';
  }

  @override
  String currentSetProgress(int current, int total) {
    return 'Serie $current / $total';
  }

  @override
  String get completeSet => 'Serie completada ✓';

  @override
  String get finishWorkout => 'Terminar entrenamiento ✓';

  @override
  String get lastExerciseLabel => '¡Último ejercicio!';

  @override
  String get restTitle => 'Descanso';

  @override
  String get skipRest => 'Saltar descanso';

  @override
  String get workoutFinishedHeadline => '¡Entrenamiento completado! 💪';

  @override
  String workoutFinishedSummary(int minutes, int count) {
    return '$minutes min · $count ejercicios completados';
  }

  @override
  String levelUpNotification(int level) {
    return '¡Subida de nivel! Has alcanzado el nivel $level';
  }

  @override
  String get startThisExercise => 'Comenzar este ejercicio';

  @override
  String get done => 'Listo';

  @override
  String secondsUnit(int seconds) {
    return '$seconds Segundos';
  }

  @override
  String get setupTitle => 'Personaliza tu viaje';

  @override
  String get continueToApp => 'Continuar a la app';

  @override
  String get languageChoice => 'Idioma';

  @override
  String get birthdayLabel => 'Cumpleaños';

  @override
  String get birthYearLabel => 'Año de nacimiento';

  @override
  String get yearsOldLabel => 'años';

  @override
  String get fitnessLevelLabel => 'Nivel de condición física';

  @override
  String get beginner => 'Principiante';

  @override
  String get beginnerDesc => 'Principiante o volviendo tras una pausa';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get intermediateDesc =>
      'Activo regularmente y acostumbrado a ejercicios con peso corporal';

  @override
  String get expert => 'Experto';

  @override
  String get expertDesc => 'Entrenamiento de alta fuerza y resistencia';

  @override
  String get bmiLabel => 'IMC';

  @override
  String get bmiUnderweight => 'Bajo peso';

  @override
  String get bmiNormal => 'Normal';

  @override
  String get bmiOverweight => 'Sobrepeso';

  @override
  String get bmiObese => 'Obesidad';

  @override
  String get jointSafetyWarningTitle => 'Atención: Cuidado Articular ⚠️';

  @override
  String get jointSafetyWarningDesc =>
      'Este movimiento ejerce un alto impacto o presión del peso corporal completo sobre las articulaciones de rodilla, tobillo o hombro. Se recomienda a principiantes o personas con masa corporal elevada usar alternativas de bajo impacto.';

  @override
  String get useSafeAlternative => 'Usar alternativa segura';

  @override
  String get proceedAnyway => 'Continuar de todos modos';

  @override
  String get recommendedAlternativeLabel => 'Alternativa recomendada';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a Rewire';

  @override
  String get onboardingWelcomeDesc =>
      'Comienza tu viaje de reconexión cerebral hoy.';

  @override
  String get onboardingPillarsTitle => 'Tres Pilares de Rewire';

  @override
  String get onboardingPillarsDesc =>
      'Registra tu progreso de recuperación, calma tu mente con meditación y mantente activo con ejercicios en casa.';

  @override
  String get onboardingLevelUpTitle => 'Sube el Nivel de tu Mente';

  @override
  String get onboardingLevelUpDesc =>
      'Las actividades positivas te dan XP. Con tu progreso, tu cerebro evoluciona a través de cinco etapas.';

  @override
  String get onboardingRemindersTitle => 'Configura Recordatorios Diarios';

  @override
  String get onboardingRemindersDesc =>
      'Elige la hora de tu check-in diario. Los recordatorios de meditación y ejercicio se pueden configurar más tarde.';

  @override
  String onboardingStepSemantics(int current, int total) {
    return 'Página $current de $total';
  }
}
