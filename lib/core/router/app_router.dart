import 'package:go_router/go_router.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/transaction/screens/transaction_screen.dart';
import '../../features/transaction/screens/sale_form_screen.dart';
import '../../features/transaction/screens/purchase_form_screen.dart';
import '../../features/transaction/screens/simple_transaction_form_screen.dart';
import '../../features/report/screens/report_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../data/models/transaction_type.dart';
import '../../shared/widgets/main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // --- StatefulShellRoute: bottom nav 4 tab ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transaction',
              name: 'transaction',
              builder: (context, state) => const TransactionScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/report',
              name: 'report',
              builder: (context, state) => const ReportScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ), // <-- StatefulShellRoute TUTUP DI SINI

    // --- Route form transaksi: SEJAJAR dengan StatefulShellRoute,
    // BUKAN di dalam salah satu branch-nya. ---
    GoRoute(
      path: '/transaction/add/:type',
      name: 'transactionForm',
      builder: (context, state) {
        final typeParam = state.pathParameters['type']!;
        final type = TransactionTypeX.fromString(typeParam);

        switch (type) {
          case TransactionType.sale:
            return const SaleFormScreen();
          case TransactionType.purchase:
            return const PurchaseFormScreen();
          case TransactionType.operational:
          case TransactionType.expense:
            return SimpleTransactionFormScreen(type: type);
        }
      },
    ),
  ],
);