require "fastimage"

class GenerateHorseImageJob < ApplicationJob
  include ActionView::Helpers::AssetUrlHelper

  attr_reader :appearance

  def perform(id)
    horse = Horses::Horse.find(id)
    @appearance = horse.appearance

    raise "background missing!" unless File.exist?(background_image)
    raise "background wrong!" unless FastImage.size(background_image).first == 1000
    raise "body missing!" unless File.exist?(body_image)
    raise "body wrong!" unless FastImage.size(body_image).first == 1000
    horse_image = ImageProcessing::Vips
      .source(background_image)
      .composite(body_image, mode: "over")
    all_markings.each do |body_part, image|
      raise leg_marking_image(body_part, image).inspect unless File.exist?(leg_marking_image(body_part, image))
      raise "leg #{appearance.gender} #{appearance.color} #{body_part} #{image} wrong!" unless FastImage.size(leg_marking_image(body_part, image)).first == 1000
      horse_image = horse_image.composite(leg_marking_image(body_part, image), mode: "over")
    end
    appearance.image.attach(io: horse_image.call, filename: "#{horse.id}.png")
    raise apperance.errors.full_messages.inspect unless appearance.valid?(:image_creation)
    appearance.save
  end

  private

  def all_markings
    {
      rf: appearance.rf_leg_image,
      lf: appearance.lf_leg_image,
      rh: appearance.rh_leg_image,
      lh: appearance.lh_leg_image
      # face: face_image
    }.compact_blank
  end

  def leg_marking_image(body_part, image)
    paths = image_path_array
    paths << "#{body_part.downcase}_#{image}"

    paths.join("/")
  end

  def body_image
    paths = image_path_array
    paths << "body.png"

    paths.join("/")
  end

  def background_image
    Rails.root.join("app/assets").to_s + image_path("horses/background.png")
  end

  def image_path_array
    paths = [Rails.root.join("app/assets/images").to_s]
    paths << "horses"
    paths << (Horses::Gender.new(appearance.gender).male? ? "stallion" : "mare")
    paths << appearance.color.downcase
    paths
  end
end

