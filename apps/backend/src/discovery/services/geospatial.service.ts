// ============================================
// FreshSave — Geospatial Service
// ============================================

import { Injectable, Logger } from '@nestjs/common';

/**
 * Handles geospatial utility operations.
 * PostGIS geography type uses meters internally, so this service
 * provides conversion helpers and coordinate validation.
 */
@Injectable()
export class GeospatialService {
  private readonly logger = new Logger(GeospatialService.name);

  /**
   * Convert kilometers to meters for PostGIS geography queries.
   * PostGIS ST_DWithin with geography type expects distance in meters.
   */
  kmToMeters(km: number): number {
    return km * 1000;
  }

  /**
   * Convert meters to kilometers for customer-facing responses.
   * Rounds to 1 decimal place for readability.
   */
  metersToKm(meters: number): number {
    return Math.round((meters / 1000) * 10) / 10;
  }

  /**
   * Validate that coordinates are within valid bounds.
   */
  isValidCoordinate(latitude: number, longitude: number): boolean {
    return (
      latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
    );
  }

  /**
   * Build a PostGIS geography point expression for parameterized queries.
   * Uses SRID 4326 (WGS 84) which matches the Store.location column definition.
   *
   * @param paramIndex - The starting parameter index ($1, $2)
   * @returns SQL fragment for creating a geography point
   */
  buildPointExpression(paramIndex: number): string {
    return `ST_SetSRID(ST_MakePoint($${paramIndex}, $${paramIndex + 1}), 4326)::geography`;
  }
}
