module TailwindHelper
  def tw_form_field_wrap(inner)
    content_tag(:div, class: "mt-1 rounded-md shadow-sm") do
      inner
    end
  end

  def tw_field
    # class: "shadow appearance-none border border-gray-300 rounded w-full py-2 px-3 bg-white focus:outline-none focus:ring-0 focus:border-blue-500 text-gray-400 leading-6 transition-colors duration-200 ease-in-out", error_class: "border-red-500", valid_class: "border-green-400"
    base = "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none"
    base += " bg-neutral-100 dark:bg-gray-200 focus:shadow-outline-blue focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5"
    base
  end

  def tw_label
    "block text-sm font-medium leading-5 text-gray-700"
  end

  def tw_boolean_field
    "w-4 h-4 border border-gray-300 rounded-sm bg-gray-50 focus:ring-3 focus:ring-blue-300 dark:bg-gray-700 dark:border-gray-600 dark:focus:ring-blue-600 dark:ring-offset-gray-800 dark:focus:ring-offset-gray-800"
  end

  def tw_boolean_label
    "ms-2 text-sm font-medium text-gray-900 dark:text-gray-300"
  end

  def tw_error_field
    "bg-red-50 border border-red-500 text-red-900 placeholder-red-700 text-sm rounded-lg focus:ring-red-500 dark:bg-gray-700 focus:border-red-500 block w-full p-2.5 dark:text-red-500 dark:placeholder-red-500 dark:border-red-500"
  end

  def tw_valid_field
    "bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 text-sm rounded-lg focus:ring-green-500 focus:border-green-500 block w-full p-2.5 dark:bg-gray-700 dark:border-green-500"
  end

  def tw_full_width_button(color: "teal")
    base = "w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white"
    base += " bg-#{color}-600 hover:bg-#{color}-500 focus:outline-none focus:border-#{color}-700"
    base += " focus:shadow-outline-#{color} active:bg-#{color}-700 transition duration-150 ease-in-out"
    base
  end

  def tw_notification(color)
    "border border-#{color}-400 rounded-b bg-#{color}-100 px-4 py-3 text-#{color}-700"
  end
end

