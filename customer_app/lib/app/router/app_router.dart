import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/showcase/design_system_showcase.dart';
import '../../features/auth/presentation/screens/auth_landing_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/all_categories_screen.dart';
import '../../features/home/presentation/screens/all_nearby_deals_screen.dart';
import '../../features/home/presentation/screens/all_nearby_stores_screen.dart';
import '../../features/home/presentation/screens/customer_shell_screen.dart';
import '../../features/discovery/presentation/screens/discovery_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/search/presentation/screens/category_discovery_screen.dart';
import '../../features/details/presentation/screens/offer_details_screen.dart';
import '../../features/details/presentation/screens/product_details_screen.dart';
import '../../features/details/presentation/screens/store_details_screen.dart';
import '../../features/reservations/presentation/screens/reservation_review_screen.dart';
import '../../features/reservations/presentation/screens/reservation_confirmation_screen.dart';
import '../../features/reservations/presentation/screens/reservation_history_screen.dart';
import '../../features/reservations/presentation/screens/reservation_detail_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/notification_preferences_screen.dart';
import '../../features/profile/presentation/screens/security_settings_screen.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart'
    as onboarding;
import '../../features/onboarding/presentation/screens/value_proposition_screen.dart';
import '../../features/onboarding/presentation/screens/location_explanation_screen.dart';
import '../../features/location/presentation/screens/location_success_screen.dart';
import '../../features/location/presentation/screens/location_fallback_screen.dart';
import '../../features/location/presentation/screens/location_selector_screen.dart';

// Owner Screens
import '../../features/owner/presentation/screens/owner_shell_screen.dart';
import '../../features/owner/presentation/screens/owner_dashboard_screen.dart';
import '../../features/owner/presentation/screens/owner_inventory_screen.dart';

import '../../features/owner/presentation/screens/owner_fulfillment_screen.dart';
import '../../features/owner/presentation/screens/owner_qr_scanner_screen.dart';
import '../../features/owner/presentation/screens/owner_add_inventory_screen.dart';
import '../../features/owner/presentation/screens/owner_reservations_screen.dart';
import '../../features/owner/presentation/screens/owner_reservation_detail_screen.dart';
import '../../features/owner/presentation/screens/owner_analytics_screen.dart';
import '../../features/owner/presentation/screens/owner_login_screen.dart';
import '../../features/owner/presentation/screens/owner_register_screen.dart';
import '../../features/owner/presentation/screens/onboarding/owner_onboarding_shell.dart';
import '../../features/owner/presentation/providers/owner_state_provider.dart';
import '../../features/owner/presentation/screens/owner_manage_store_screen.dart';
import '../../features/owner/presentation/screens/owner_inventory_detail_screen.dart';
import '../../features/owner/presentation/screens/owner_product_list_screen.dart';
import '../../features/owner/presentation/screens/owner_product_detail_screen.dart';
import '../../features/owner/presentation/screens/owner_offer_list_screen.dart';
import '../../features/owner/presentation/screens/owner_offer_detail_screen.dart';
import '../../features/owner/presentation/screens/create_offer_screen.dart';
import '../../features/owner/presentation/screens/owner_notifications_screen.dart';
import '../../features/owner/presentation/screens/owner_settings_screen.dart';
import '../../features/owner/presentation/screens/owner_team_screen.dart';
import '../../features/owner/presentation/screens/owner_security_screen.dart';
import '../../features/owner/presentation/screens/owner_notification_preferences_screen.dart';

// Admin Screens
import '../../features/admin/presentation/screens/admin_shell_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_users_screen.dart';
import '../../features/admin/presentation/screens/admin_stores_screen.dart';
import '../../features/admin/presentation/screens/admin_audit_logs_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final ownerState = ref.watch(ownerStateProvider);
  final hasCompletedOnboarding = ref.watch(onboardingProvider);

  return GoRouter(
    initialLocation: '/role-selection',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthRoute =
          state.matchedLocation == '/role-selection' ||
          state.matchedLocation == '/welcome' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/owner/login' ||
          state.matchedLocation == '/owner/register';
      final isShowcase = state.matchedLocation == '/showcase';
      final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');
      final isOwnerOnboardingRoute = state.matchedLocation.startsWith(
        '/owner/onboarding',
      );

      if (isShowcase) return null;

      if (authState.status == AuthStatus.unknown) return null;

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final userRole = authState.user?.role ?? 'CUSTOMER';
      final isAdmin = userRole == 'ADMIN' || userRole == 'SUPER_ADMIN';
      final isOwner = userRole == 'SHOP_OWNER' || userRole == 'SHOP_STAFF';

      if (!isAuthenticated) {
        return isAuthRoute ? null : '/role-selection';
      }

      // Admin routing isolation
      if (isAdmin) {
        if (state.matchedLocation.startsWith('/admin')) return null;
        return '/admin/dashboard';
      }

      // Owner routing isolation
      if (isOwner) {
        // Always redirect away from auth screens for an authenticated owner
        if (state.matchedLocation == '/owner/login' ||
            state.matchedLocation == '/owner/register' ||
            isAuthRoute) {
          // Wait until owner context has loaded before redirecting
          if (ownerState.contextState == OwnerContextState.initial ||
              ownerState.contextState == OwnerContextState.loading) {
            // Context is still loading — stay put (avoids premature redirect)
            return null;
          }
          if (ownerState.contextState == OwnerContextState.noBusiness ||
              ownerState.contextState == OwnerContextState.noStore) {
            return '/owner/onboarding';
          }
          return '/owner/dashboard';
        }

        // Context still loading — allow any /owner/* route to render
        if (ownerState.contextState == OwnerContextState.loading ||
            ownerState.contextState == OwnerContextState.initial) {
          if (state.matchedLocation.startsWith('/owner')) {
            return null;
          }
          return '/owner/dashboard';
        }

        if (ownerState.contextState == OwnerContextState.noBusiness ||
            ownerState.contextState == OwnerContextState.noStore) {
          return isOwnerOnboardingRoute ? null : '/owner/onboarding';
        }

        if (isOwnerOnboardingRoute) {
          return '/owner/dashboard';
        }

        if (state.matchedLocation.startsWith('/owner')) {
          return null;
        }
        return '/owner/dashboard';
      }

      // Customer routing isolation
      if (isAuthRoute || state.matchedLocation.startsWith('/owner')) {
        return hasCompletedOnboarding ? '/home' : '/onboarding/welcome';
      }

      // Authenticated users (customers)
      if (!hasCompletedOnboarding) {
        return isOnboardingRoute ? null : '/onboarding/welcome';
      }

      // Authenticated AND completed onboarding
      if (isAuthRoute || isOnboardingRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/showcase',
        builder: (context, state) => const DesignSystemShowcase(),
      ),
      // --- Auth Routes ---
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const AuthLandingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/owner/login',
        builder: (context, state) => const OwnerLoginScreen(),
      ),
      GoRoute(
        path: '/owner/register',
        builder: (context, state) => const OwnerRegisterScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // --- Onboarding Routes ---
      GoRoute(
        path: '/onboarding/welcome',
        builder: (context, state) => const onboarding.WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/value',
        builder: (context, state) => const ValuePropositionScreen(),
      ),
      GoRoute(
        path: '/onboarding/location',
        builder: (context, state) => const LocationExplanationScreen(),
      ),
      GoRoute(
        path: '/onboarding/location-success',
        builder: (context, state) => const LocationSuccessScreen(),
      ),
      GoRoute(
        path: '/onboarding/location-fallback',
        builder: (context, state) => const LocationFallbackScreen(),
      ),
      // --- Owner Onboarding ---
      GoRoute(
        path: '/owner/onboarding',
        builder: (context, state) => const OwnerOnboardingShell(),
      ),
      // --- Owner Routes ---
      ShellRoute(
        builder: (context, state, child) => OwnerShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/owner/dashboard',
            builder: (context, state) => const OwnerDashboardScreen(),
          ),
          GoRoute(
            path: '/owner/notifications',
            builder: (context, state) => const OwnerNotificationScreen(),
          ),

          GoRoute(
            path: '/owner/inventory',
            builder: (context, state) => const OwnerInventoryScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'owner_add_inventory',
                builder: (context, state) => const OwnerAddInventoryScreen(),
              ),
              GoRoute(
                path: ':id',
                name: 'owner_inventory_detail',
                builder: (context, state) => OwnerInventoryDetailScreen(
                  inventoryId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/owner/products',
            builder: (context, state) => const OwnerProductListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => OwnerProductDetailScreen(
                  productId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/owner/offers',
            builder: (context, state) => const OwnerOfferListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateOfferScreen(),
              ),

              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return OwnerOfferDetailScreen(offerId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/owner/reservations',
            builder: (context, state) => const OwnerReservationsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return OwnerReservationDetailScreen(reservationId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/owner/fulfillment',
            builder: (context, state) => const OwnerFulfillmentScreen(),
            routes: [
              GoRoute(
                path: 'scan',
                builder: (context, state) {
                  final code = state.uri.queryParameters['code'];
                  return OwnerQrScannerScreen(initialCode: code);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/owner/analytics',
            builder: (context, state) => const OwnerAnalyticsScreen(),
          ),
          GoRoute(
            path: '/owner/profile',
            builder: (context, state) => const OwnerManageStoreScreen(),
          ),
          GoRoute(
            path: '/owner/settings',
            builder: (context, state) => const OwnerSettingsScreen(),
            routes: [
              GoRoute(
                path: 'team',
                builder: (context, state) => const OwnerTeamScreen(),
              ),
              GoRoute(
                path: 'security',
                builder: (context, state) => const OwnerSecurityScreen(),
              ),
              GoRoute(
                path: 'notifications',
                builder: (context, state) =>
                    const OwnerNotificationPreferencesScreen(),
              ),
            ],
          ),
        ],
      ),
      // --- Admin Routes ---
      ShellRoute(
        builder: (context, state, child) => AdminShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: '/admin/stores',
            builder: (context, state) => const AdminStoresScreen(),
          ),
          GoRoute(
            path: '/admin/audit-logs',
            builder: (context, state) => const AdminAuditLogsScreen(),
          ),
          GoRoute(
            path: '/admin/notifications',
            builder: (context, state) => const NotificationScreen(),
          ),
        ],
      ),
      // --- App Routes (Customer) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CustomerShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const AllCategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/deals/nearby', builder: (context, state) => const AllNearbyDealsScreen()),
      GoRoute(path: '/stores/nearby', builder: (context, state) => const AllNearbyStoresScreen()),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      // --- Future Milestones ---
      GoRoute(
        path: '/category/:id',
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CategoryDiscoveryScreen(categoryId: categoryId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),
      GoRoute(
        path: '/offer/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: OfferDetailsScreen(offerId: id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuad,
                          ),
                        ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/product/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailsScreen(productId: id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuad,
                          ),
                        ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/store/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: StoreDetailsScreen(storeId: id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuad,
                          ),
                        ),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/reservation/history',
        builder: (context, state) => const ReservationHistoryScreen(),
      ),
      GoRoute(
        path: '/reservation/review/:offerId',
        builder: (context, state) =>
            ReservationReviewScreen(offerId: state.pathParameters['offerId']!),
      ),
      GoRoute(
        path: '/reservation/success/:id',
        builder: (context, state) => ReservationConfirmationScreen(
          reservationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/reservation/:id',
        builder: (context, state) => ReservationDetailScreen(
          reservationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/location-selector',
        builder: (context, state) => const LocationSelectorScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: '/profile/security',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
    ],
  );
});
