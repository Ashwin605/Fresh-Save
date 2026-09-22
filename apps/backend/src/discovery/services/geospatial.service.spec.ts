// ============================================
// FreshSave — Geospatial Service Tests
// ============================================

import { Test, TestingModule } from '@nestjs/testing';
import { GeospatialService } from './geospatial.service';

describe('GeospatialService', () => {
  let service: GeospatialService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [GeospatialService],
    }).compile();

    service = module.get<GeospatialService>(GeospatialService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('kmToMeters', () => {
    it('should convert kilometers to meters', () => {
      expect(service.kmToMeters(1)).toBe(1000);
      expect(service.kmToMeters(5)).toBe(5000);
      expect(service.kmToMeters(0.5)).toBe(500);
    });
  });

  describe('metersToKm', () => {
    it('should convert meters to kilometers rounded to 1 decimal', () => {
      expect(service.metersToKm(1000)).toBe(1);
      expect(service.metersToKm(2400)).toBe(2.4);
      expect(service.metersToKm(500)).toBe(0.5);
      expect(service.metersToKm(1234)).toBe(1.2);
    });
  });

  // ── Test 1: Valid latitude accepted ──────────────────────
  describe('isValidCoordinate', () => {
    it('should accept valid latitude', () => {
      expect(service.isValidCoordinate(12.9165, 79.1325)).toBe(true);
      expect(service.isValidCoordinate(0, 0)).toBe(true);
      expect(service.isValidCoordinate(90, 180)).toBe(true);
      expect(service.isValidCoordinate(-90, -180)).toBe(true);
    });

    // ── Test 2: Invalid latitude rejected ──────────────────
    it('should reject invalid latitude', () => {
      expect(service.isValidCoordinate(91, 0)).toBe(false);
      expect(service.isValidCoordinate(-91, 0)).toBe(false);
    });

    // ── Test 3: Valid longitude accepted ────────────────────
    it('should accept valid longitude', () => {
      expect(service.isValidCoordinate(0, 179)).toBe(true);
      expect(service.isValidCoordinate(0, -179)).toBe(true);
    });

    // ── Test 4: Invalid longitude rejected ─────────────────
    it('should reject invalid longitude', () => {
      expect(service.isValidCoordinate(0, 181)).toBe(false);
      expect(service.isValidCoordinate(0, -181)).toBe(false);
    });
  });

  describe('buildPointExpression', () => {
    it('should build parameterized point expression', () => {
      const expr = service.buildPointExpression(1);
      expect(expr).toContain('$1');
      expect(expr).toContain('$2');
      expect(expr).toContain('4326');
      expect(expr).toContain('geography');
    });
  });
});
