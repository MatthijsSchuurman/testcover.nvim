package example

import (
  "testing"
)

func TestIntegrationHello(t *testing.T) {
  // Given
  expected := "Hello, world!"

  // When
  actual := Hello()

  // Then
  if actual != expected {
    t.Errorf("got %v, want %v", actual, expected)
  }
}
