// File Dependencies
import { WS_EVENT_NAMES, DATA_STORAGE_TYPES } from "./lib/constants.js";
import { serialize, deserialize } from "./lib/dataTransformer.js";
import { EventListenersInterface, StorageParams } from "./lib/validators.js";

/**
 * Retrieves the storage API for the browser
 */
const getStorage = (storageType: string) => {
  switch (storageType) {
    case "local":
      return window.localStorage;
    case "session":
      return window.sessionStorage;
  }
};

/**
 * Retrieves the messages in the message queue from one of either
 * sessionStorage or localStorage.
 */
const getMessagesFromStore = ({ storageType, storageKey, storageValue }: StorageParams) => {
  if (DATA_STORAGE_TYPES.indexOf(storageType) !== -1) {
    const storage = getStorage(storageType);
    const rawData: null | string =
      (storage && storage.getItem(storageKey)) || null;
    return deserialize(rawData) || [];
  }
};

/**
 * Store messages in the message queue from one of either
 * sessionStorage or localStorage.
 */
const storeMessagesInStore = ({ storageType, storageKey, storageValue }: StorageParams) => {
  if (DATA_STORAGE_TYPES.indexOf(storageType) !== -1) {
    const storage = getStorage(storageType);
    return (storage && storage.setItem(storageKey, serialize(storageValue))) || null;
  }
};
