/// Authoritative list of [strings] keys the UI requires at runtime.
/// Keep in sync with [MainShell] / [BillCalculatorTab] and README "Configuration contract".
const Set<String> kRequiredUiStringKeys = {
  'nav_tab_calculate',
  'nav_tab_devices',
  'nav_tab_about',
  'page_intro',
  'meter_section_label',
  'input_error',
  'input_error_zero',
  'units_label',
  'units_hint',
  'units_helper',
  'calculate_button',
  'clear_button',
  'result_empty_hint',
  'estimate_chip',
  'tier_incomplete_warning',
  'result_heading',
  'breakdown_heading',
  'footnote',
  'maintenance_fee_checkbox',
  'maintenance_fee_breakdown',
};
