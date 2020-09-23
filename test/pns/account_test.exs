defmodule Pns.AccountTest do
  use Pns.DataCase

  alias Pns.Account

  describe "events" do
    alias Pns.Account.Event

    @valid_attrs %{
      end_time: ~N[2010-04-17 14:00:00],
      html_template: "some html_template",
      key: "7488a646-e31f-11e4-aace-600308960662",
      start_time: ~N[2010-04-17 14:00:00],
      website_url: "some website_url"
    }
    @update_attrs %{
      end_time: ~N[2011-05-18 15:01:01],
      html_template: "some updated html_template",
      key: "7488a646-e31f-11e4-aace-600308960668",
      start_time: ~N[2011-05-18 15:01:01],
      website_url: "some updated website_url"
    }
    @invalid_attrs %{
      end_time: nil,
      html_template: nil,
      key: nil,
      start_time: nil,
      website_url: nil
    }

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Account.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Account.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Account.create_event(@valid_attrs)
      assert event.end_time == ~N[2010-04-17 14:00:00]
      assert event.html_template == "some html_template"
      assert event.key == "7488a646-e31f-11e4-aace-600308960662"
      assert event.start_time == ~N[2010-04-17 14:00:00]
      assert event.website_url == "some website_url"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Account.update_event(event, @update_attrs)
      assert event.end_time == ~N[2011-05-18 15:01:01]
      assert event.html_template == "some updated html_template"
      assert event.key == "7488a646-e31f-11e4-aace-600308960668"
      assert event.start_time == ~N[2011-05-18 15:01:01]
      assert event.website_url == "some updated website_url"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_event(event, @invalid_attrs)
      assert event == Account.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Account.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Account.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Account.change_event(event)
    end
  end
end
