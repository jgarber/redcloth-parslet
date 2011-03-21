class RedClothParslet::Transform::Inline < Parslet::Transform
  rule(:s => simple(:s)) { String(s) }
end